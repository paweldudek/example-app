/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "RootFlowViewController.h"
#import "ContainerView.h"
#import "LoadingView.h"
#import "UsersViewController.h"
#import "AllUsersProvider.h"
#import "ViewControllerPresenter.h"


@implementation RootFlowViewController

- (void)loadView {
    UINavigationController *navigationController = [self rootNavigationController];

    ContainerView *view = [[ContainerView alloc] init];
    view.containedView = navigationController.view;

    self.view = view;

    [navigationController didMoveToParentViewController:self];
}

#pragma mark - Loading Helpers

- (UINavigationController *)rootNavigationController {
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    [self addChildViewController:navigationController];

    AllUsersProvider *allUsersProvider = [[AllUsersProvider alloc] init];
    UsersViewController *usersViewController = [[UsersViewController alloc] initWithUsersProvider:allUsersProvider];
    usersViewController.delegate = self;

    navigationController.viewControllers = @[usersViewController];
    return navigationController;
}

#pragma mark - Dynamic View Getter

- (ContainerView *)containerView {
    ContainerView *containerView = nil;
    if ([self isViewLoaded]) {
        containerView = (ContainerView *) [self view];
    }
    return containerView;
}

#pragma mark - Users View Controller Delegate

- (void)usersViewController:(UsersViewController *)viewController didSelectUser:(User *)user {

}

@end
