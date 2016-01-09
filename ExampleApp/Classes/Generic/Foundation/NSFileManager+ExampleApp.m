/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "NSFileManager+ExampleApp.h"


@implementation NSFileManager (ExampleApp)

- (NSURL *)applicationSupportDirectoryURL {
    return [[self URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] firstObject];
}

@end
