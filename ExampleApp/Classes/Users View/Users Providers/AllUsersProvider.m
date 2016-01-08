/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AllUsersProvider.h"
#import "UserController.h"


@implementation AllUsersProvider
@synthesize delegate;

- (instancetype)initWithUserController:(UserController *)userController {
    self = [super init];
    if (self) {
        _userController = userController;
    }

    return self;
}

#pragma mark - Content Provider

- (NSString *)title {
    return NSLocalizedString(@"Users", nil);
}

- (void)updateContent {
    [self.delegate contentProviderWillBeginUpdatingData:self];

    [self.userController updateUsersWithCompletion:^(NSError *error){}];

}

#pragma mark - Users Provider

- (User *)userAtIndex:(NSUInteger)index {
    return nil;
}

- (NSUInteger)numberOfUsers {
    return 0;
}

@end
