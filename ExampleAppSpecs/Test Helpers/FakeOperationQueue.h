/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>


@interface FakeOperationQueue : NSOperationQueue

- (void)runLastOperation;

- (void)runLastBlockOperation;

@end
