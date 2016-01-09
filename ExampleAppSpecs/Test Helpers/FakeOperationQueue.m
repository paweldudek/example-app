/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "FakeOperationQueue.h"

@interface FakeOperationQueue ()
@property(nonatomic, strong) NSOperation *lastAddedOperation;
@property(nonatomic, copy) void (^lastBlockOperation)();
@end

@implementation FakeOperationQueue

#pragma mark - Operations

- (void)addOperation:(NSOperation *)op {
    self.lastAddedOperation = op;
}

- (void)runLastOperation {
    NSAssert(self.lastAddedOperation, @"Attempted to executeWithContext: last added operation, but no operation was captured.");
    [self.lastAddedOperation start];
}

#pragma mark - Block Operations

- (void)addOperationWithBlock:(void (^)(void))block {
    self.lastBlockOperation = block;
}

- (void)runLastBlockOperation {
    NSAssert(self.lastBlockOperation, @"Attempted to executeWithContext: last added block operation, but no operation was captured.");

    if (self.lastBlockOperation) {
        self.lastBlockOperation();
    }
}

@end
