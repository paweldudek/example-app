/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "UserAlbumsProvider.h"
#import "User.h"


@implementation UserAlbumsProvider
@synthesize delegate;

- (instancetype)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        _user = user;
    }

    return self;
}

#pragma mark - Content Provider

- (NSString *)title {
    return self.user.name;
}

- (void)updateContent {

}

@end
