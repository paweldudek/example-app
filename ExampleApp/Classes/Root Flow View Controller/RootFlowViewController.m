/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "RootFlowViewController.h"
#import "ContainerView.h"
#import "LoadingView.h"
#import "UsersViewController.h"
#import "AllUsersProvider.h"
#import "ViewControllerPresenter.h"
#import "AlbumsViewController.h"
#import "NavigationViewControllerPresenter.h"
#import "AlbumPhotosViewController.h"
#import "ApplicationController.h"


@implementation RootFlowViewController

- (instancetype)initWithApplicationController:(ApplicationController *)applicationController {
    self = [super init];
    if (self) {
        _applicationController = applicationController;
    }

    return self;
}

#pragma mark - UIViewController

- (void)loadView {
    UINavigationController *navigationController = [self rootNavigationController];

    self.viewControllerPresenter = [[NavigationViewControllerPresenter alloc] initWithNavigationController:navigationController];

    ContainerView *view = [[ContainerView alloc] init];
    view.containedView = navigationController.view;

    self.view = view;

    [navigationController didMoveToParentViewController:self];
}

#pragma mark - Loading Helpers

- (UINavigationController *)rootNavigationController {
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    [self addChildViewController:navigationController];

    AllUsersProvider *allUsersProvider = [[AllUsersProvider alloc] initWithUserController:self.applicationController.userController];
    UsersViewController *usersViewController = [[UsersViewController alloc] initWithUsersProvider:allUsersProvider];
    usersViewController.delegate = self;

    navigationController.viewControllers = @[usersViewController];
    return navigationController;
}

#pragma mark - Users View Controller Delegate

- (void)usersViewController:(UsersViewController *)viewController didSelectUser:(User *)user {
    AlbumsViewController *albumsViewController = [[AlbumsViewController alloc] init];
    albumsViewController.delegate = self;
    [self.viewControllerPresenter pushViewController:albumsViewController animated:YES completion:nil];
}

#pragma mark - Albums View Controller Delegate

- (void)albumsViewController:(AlbumsViewController *)viewController didSelectAlbum:(Album *)album {
    AlbumPhotosViewController *albumPhotosViewController = [[AlbumPhotosViewController alloc] init];
    [self.viewControllerPresenter pushViewController:albumPhotosViewController animated:YES completion:nil];
}

@end
