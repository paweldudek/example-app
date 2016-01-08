/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AbstractAsynchronousOperation.h"


@implementation AbstractAsynchronousOperation {
    BOOL _isFinished;
    BOOL _isExecuting;
}

- (void)start {
    self.executing = YES;
}

- (void)cancel {
    [super cancel];

    [self finishExecution];
}

- (void)finishExecution {
    self.executing = NO;
    self.finished = YES;
}

#pragma mark - Overriden Setters & Getters

- (void)setFinished:(BOOL)finished {
    if (_isFinished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (BOOL)isFinished {
    return _isFinished;
}

- (void)setExecuting:(BOOL)executing {
    if (_isExecuting != executing) {
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (BOOL)isExecuting {
    return _isExecuting;
}

#pragma mark -

- (BOOL)isAsynchronous {
    return YES;
}

@end
