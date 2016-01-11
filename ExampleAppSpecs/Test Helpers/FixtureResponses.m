/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "FixtureResponses.h"


@implementation FixtureResponses

+ (NSArray *)fixtureUsersResponse {
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[self pathForJSONResourceWithName:@"Users"]]
                                           options:0
                                             error:nil];
}

+ (NSArray *)fixtureAlbumsResponse {
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[self pathForJSONResourceWithName:@"Albums"]]
                                           options:0
                                             error:nil];
}

+ (NSString *)pathForJSONResourceWithName:(NSString *)name {
    return [[NSBundle bundleForClass:self] pathForResource:name ofType:@"JSON"];
}
@end
