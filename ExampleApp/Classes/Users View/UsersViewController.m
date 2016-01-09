/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "UsersViewController.h"
#import "User.h"
#import "ContainerView.h"


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

- (void)loadView {
    [super loadView];

    UITableViewController *viewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:viewController];

    ContainerView *containerView = [[ContainerView alloc] init];
    containerView.containedView = viewController.view;

    self.view = containerView;

    [viewController didMoveToParentViewController:self];

    viewController.tableView.delegate = self;
    viewController.tableView.dataSource = self;
}

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

#pragma mark - UITableView Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersProvider.numberOfUsers;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
