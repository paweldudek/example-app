/*
 * Copyright (c) 2015 Dudek. All rights reserved.
 */
#import "NSBundle+PBDBundleVersionString.h"


@implementation NSBundle (PBDBundleVersionString)

- (NSString *)pbd_bundleVersionString {
    return [NSString stringWithFormat:@"%@ (%@)",
                                      [self infoDictionary][@"CFBundleShortVersionString"],
                                      [self infoDictionary][@"CFBundleVersion"]];;
}

@end
