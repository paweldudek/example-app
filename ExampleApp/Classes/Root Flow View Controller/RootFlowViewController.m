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
#import "UserAlbumsProvider.h"
#import "SearchUsersProvider.h"


@interface RootFlowViewController ()
@property(nonatomic, readwrite) UISearchController *userSearchController;
@end

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
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    [self addChildViewController:navigationController];

    UsersViewController *usersViewController = [self usersViewController];
    navigationController.viewControllers = @[usersViewController];

    self.viewControllerPresenter = [[NavigationViewControllerPresenter alloc] initWithNavigationController:navigationController];

    ContainerView *view = [[ContainerView alloc] init];
    view.containedView = navigationController.view;

    self.view = view;

    [navigationController didMoveToParentViewController:self];

    // Force view load so that we get the table view
    [usersViewController loadViewIfNeeded];
    SearchUsersProvider *searchUsersProvider = [[SearchUsersProvider alloc] initWithPersistenceController:self.applicationController.persistenceController];

    UsersViewController *usersSearchViewController = [[UsersViewController alloc] initWithUsersProvider:searchUsersProvider];
    usersSearchViewController.delegate = self;
    self.userSearchController = [[UISearchController alloc] initWithSearchResultsController:usersSearchViewController];
    self.userSearchController.searchResultsUpdater = searchUsersProvider;
    usersViewController.tableView.tableHeaderView = self.userSearchController.searchBar;
}

#pragma mark - Loading Helpers

- (UsersViewController *)usersViewController {
    AllUsersProvider *allUsersProvider = [[AllUsersProvider alloc] initWithUserController:self.applicationController.userController];
    UsersViewController *usersViewController = [[UsersViewController alloc] initWithUsersProvider:allUsersProvider];
    usersViewController.delegate = self;
    return usersViewController;
}

#pragma mark - Users View Controller Delegate

- (void)usersViewController:(UsersViewController *)viewController didSelectUser:(User *)user {
    UserAlbumsProvider *albumsProvider = [[UserAlbumsProvider alloc] initWithUser:user
                                                                  albumController:self.applicationController.albumController
                                                            persistenceController:self.applicationController.persistenceController];

    AlbumsViewController *albumsViewController = [[AlbumsViewController alloc] initWithAlbumsProvider:albumsProvider];
    albumsViewController.delegate = self;
    [self.viewControllerPresenter pushViewController:albumsViewController animated:YES completion:nil];
}

#pragma mark - Albums View Controller Delegate

- (void)albumsViewController:(AlbumsViewController *)viewController didSelectAlbum:(Album *)album {
    AlbumPhotosViewController *albumPhotosViewController = [[AlbumPhotosViewController alloc] init];
    [self.viewControllerPresenter pushViewController:albumPhotosViewController animated:YES completion:nil];
}

@end
