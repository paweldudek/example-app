/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "RootFlowViewController.h"
#import "ContainerView.h"
#import "AllUsersProvider.h"
#import "ViewControllerPresenter.h"
#import "NavigationViewControllerPresenter.h"
#import "ApplicationController.h"
#import "UserAlbumsProvider.h"
#import "SearchUsersProvider.h"
#import "AlbumPhotosProvider.h"


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

    TableContentViewController *usersViewController = [self usersViewController];
    navigationController.viewControllers = @[usersViewController];

    self.viewControllerPresenter = [[NavigationViewControllerPresenter alloc] initWithNavigationController:navigationController];

    ContainerView *view = [[ContainerView alloc] init];
    view.containedView = navigationController.view;

    self.view = view;

    [navigationController didMoveToParentViewController:self];

    // Force view load so that we get the table view
    [usersViewController loadViewIfNeeded];
    SearchUsersProvider *searchUsersProvider = [[SearchUsersProvider alloc] initWithPersistenceController:self.applicationController.persistenceController];

    UserPresentationController *userPresentationController = [[UserPresentationController alloc] init];
    userPresentationController.delegate = self;
    TableContentViewController *usersSearchViewController = [[TableContentViewController alloc] initWithContentProvider:searchUsersProvider
                                                                                     tableContentPresentationController:userPresentationController];
    self.userSearchController = [[UISearchController alloc] initWithSearchResultsController:usersSearchViewController];
    self.userSearchController.searchResultsUpdater = searchUsersProvider;
    usersViewController.tableView.tableHeaderView = self.userSearchController.searchBar;
}

#pragma mark - Loading Helpers

- (TableContentViewController *)usersViewController {
    AllUsersProvider *allUsersProvider = [[AllUsersProvider alloc] initWithUserController:self.applicationController.userController
                                                                    persistenceController:self.applicationController.persistenceController];
    UserPresentationController *userPresentationController = [[UserPresentationController alloc] init];
    userPresentationController.delegate = self;
    TableContentViewController *usersViewController = [[TableContentViewController alloc] initWithContentProvider:allUsersProvider
                                                                               tableContentPresentationController:userPresentationController];
    return usersViewController;
}

#pragma mark - Users Presentation Controller Delegate

- (void)userPresentationController:(UserPresentationController *)presentationController didSelectUser:(User *)user {
    UserAlbumsProvider *albumsProvider = [[UserAlbumsProvider alloc] initWithUser:user
                                                                  albumController:self.applicationController.albumController
                                                            persistenceController:self.applicationController.persistenceController];

    AlbumPresentationController *albumPresentationController = [[AlbumPresentationController alloc] init];
    albumPresentationController.delegate = self;

    TableContentViewController *albumsViewController = [[TableContentViewController alloc] initWithContentProvider:albumsProvider
                                                                                tableContentPresentationController:albumPresentationController];
    [self.viewControllerPresenter pushViewController:albumsViewController animated:YES completion:nil];
}

#pragma mark - Albums Presentation Controller Delegate

- (void)albumPresentationController:(AlbumPresentationController *)controller didSelectAlbum:(Album *)album {
    AlbumPhotosProvider *albumPhotosProvider = [[AlbumPhotosProvider alloc] initWithAlbum:album
                                                                          albumController:self.applicationController.albumController
                                                                    persistenceController:self.applicationController.persistenceController];
    
    TableContentViewController *albumsViewController = [[TableContentViewController alloc] initWithContentProvider:albumPhotosProvider
                                                                                tableContentPresentationController:nil];
    [self.viewControllerPresenter pushViewController:albumsViewController animated:YES completion:nil];
}

@end
