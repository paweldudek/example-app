
/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "UsersViewController.h"
#import "User.h"
#import "ContainerView.h"
#import "UserTableViewCell.h"
#import "Company.h"


@interface UsersViewController ()
@property(nonatomic, readwrite) UITableView *tableView;
@end

@implementation UsersViewController

- (instancetype)initWithUsersProvider:(id <UsersProvider>)usersProvider {
    self = [super init];
    if (self) {
        _usersProvider = usersProvider;
        _usersProvider.delegate = self;
        self.title = _usersProvider.title;

        self.definesPresentationContext = YES;
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

    UITableView *tableView = viewController.tableView;
    tableView.delegate = self;
    tableView.dataSource = self;

    UINib *cellNib = [UINib nibWithNibName:@"UserTableViewCell" bundle:nil];
    [tableView registerNib:cellNib forCellReuseIdentifier:@"Cell"];

    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.usersProvider updateContent];
}

#pragma mark - Content Provider Delegate

- (void)contentProviderWillBeginUpdatingData:(id <ContentProvider>)contentProvider {
    //TODO: display loading indicator
}

- (void)contentProviderDidFinishUpdatingData:(id <ContentProvider>)contentProvider {
    //TODO: hide loading indicator
}

- (void)contentProviderDidUpdateContent:(id <ContentProvider>)contentProvider {
    [self.tableView reloadData];
}

#pragma mark - UITableView Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersProvider.numberOfUsers;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [self.usersProvider userAtIndex:indexPath.row];
    [self.delegate usersViewController:self didSelectUser:user];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    User *user = [self.usersProvider userAtIndex:indexPath.row];
    cell.nameLabel.text = user.name;
    cell.emailLabel.text = user.email;
    cell.companyCatchPhraseLabel.text = user.company.catchphrase;

    return cell;
}

@end
