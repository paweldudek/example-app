/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AllUsersProvider.h"
#import "UserController.h"
#import "NSManagedObject+Convenience.h"
#import "User.h"
#import "PersistenceController.h"


@interface AllUsersProvider ()
@property(nonatomic, strong) NSArray *allUsers;
@end

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
    self.allUsers = [User allFromContext:self.userController.persistenceController.mainThreadManagedObjectContext];

    [self.userController updateUsersWithCompletion:^(NSError *error) {
        self.allUsers = [User allFromContext:self.userController.persistenceController.mainThreadManagedObjectContext];
        [self.delegate contentProviderDidUpdateContent:self];
    }];
}

#pragma mark - Users Provider

- (User *)userAtIndex:(NSInteger)index {
    return self.allUsers[(NSUInteger) index];
}

- (NSUInteger)numberOfUsers {
    return self.allUsers.count;
}

@end
