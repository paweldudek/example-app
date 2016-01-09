/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "NetworkLayer+ExampleApp.h"


@implementation NetworkLayer (ExampleApp)

+ (instancetype)exampleAppNetworkLayer {
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://jsonplaceholder.typicode.com"]];
}

@end
