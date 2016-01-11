
/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "TableContentViewController.h"
#import "User.h"
#import "ContainerView.h"
#import "UserTableViewCell.h"
#import "Company.h"
#import "LoadingView.h"
#import "TableContentPresentationController.h"


@interface TableContentViewController ()
@property(nonatomic, readwrite) UITableView *tableView;
@end

@implementation TableContentViewController

- (instancetype)initWithContentProvider:(id <ContentProvider>)contentProvider tableContentPresentationController:(id <TableContentPresentationController>)tableContentPresentationController {
    self = [super init];
    if (self) {
        _contentProvider = contentProvider;
        _contentProvider.delegate = self;

        _tableContentPresentationController = tableContentPresentationController;

        self.title = _contentProvider.title;
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
    LoadingView *loadingView = [[LoadingView alloc] init];
    loadingView.alpha = 0.0f;
    containerView.overlayView = loadingView;

    self.view = containerView;

    [viewController didMoveToParentViewController:self];

    UITableView *tableView = viewController.tableView;
    tableView.delegate = self;
    tableView.dataSource = self;

    [tableView registerNib:self.tableContentPresentationController.tableViewCellNib forCellReuseIdentifier:@"Cell"];

    self.tableView = tableView;
    self.tableContentPresentationController.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.contentProvider updateContent];
}

#pragma mark - Dynamic View Getter

- (ContainerView *)containerView {
    ContainerView *containerView = nil;
    if ([self isViewLoaded]) {
        containerView = (ContainerView *) [self view];
    }
    return containerView;
}

#pragma mark - Content Provider Delegate

- (void)contentProviderWillBeginUpdatingData:(id <ContentProvider>)contentProvider {
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.overlayView.alpha = 1.0f;
    }];
}

- (void)contentProviderDidFinishUpdatingData:(id <ContentProvider>)contentProvider {
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.overlayView.alpha = 0.0f;
    }];
}

- (void)contentProviderDidUpdateContent:(id <ContentProvider>)contentProvider {
    [self.tableView reloadData];
}

#pragma mark - UITableView Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentProvider.numberOfObjects;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.contentProvider objectAtIndex:indexPath.row];
    [self.tableContentPresentationController selectObject:object];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableContentPresentationController.estimatedCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    id object = [self.contentProvider objectAtIndex:indexPath.row];
    [self.tableContentPresentationController configureTableViewCell:cell atIndexPath:indexPath withObject:object];

    return cell;
}

@end
