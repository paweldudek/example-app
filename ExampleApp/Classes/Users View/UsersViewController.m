/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "UsersViewController.h"
#import "User.h"


@implementation UsersViewController

- (instancetype)initWithUsersProvider:(id <UsersProvider>)usersProvider {
    self = [super init];
    if (self) {
        _usersProvider = usersProvider;
        self.title = NSLocalizedString(@"Users", nil);
    }

    return self;
}

#pragma mark -

@end
