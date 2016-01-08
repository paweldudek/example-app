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
        _usersProvider.delegate = self;
        self.title = _usersProvider.title;
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.usersProvider updateContent];
}

#pragma mark - Content Provider Delegate

- (void)contentProviderWillBeginUpdatingData:(id <ContentProvider>)contentProvider {

}

- (void)contentProviderDidFinishUpdatingData:(id <ContentProvider>)contentProvider {

}

- (void)contentProviderDidUpdateContent:(id <ContentProvider>)contentProvider {

}

@end
