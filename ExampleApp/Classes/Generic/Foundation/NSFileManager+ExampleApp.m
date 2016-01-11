/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "NSFileManager+ExampleApp.h"


@implementation NSFileManager (ExampleApp)

- (NSURL *)applicationSupportDirectoryURL {
    return [[self URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] firstObject];
}

- (NSURL *)generateNewTemporaryDirectoryURL {
    NSURL *directoryURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]] isDirectory:YES];
    [[NSFileManager defaultManager] createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:nil];
    return directoryURL;
}

@end
