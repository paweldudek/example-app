#import "Specs.h"

#import "RootFlowViewController.h"
#import "ContainerView.h"
#import "AllUsersProvider.h"
#import "LoadingView.h"
#import "ViewControllerPresenter.h"
#import "NavigationViewControllerPresenter.h"
#import "NSManagedObjectContext+SpecHelpers.h"
#import "NSManagedObject+SpecHelpers.h"
#import "User.h"
#import "HCArgumentCaptor.h"
#import "AlbumsViewController.h"
#import "AlbumPhotosViewController.h"
#import "Album.h"
#import "ApplicationController.h"
#import "UserController.h"
#import "UserAlbumsProvider.h"
#import "SearchUsersProvider.h"
#import "PersistenceController.h"

SpecBegin(RootFlowViewController)

describe(@"RootFlowViewController", ^{

    __block RootFlowViewController *sut;

    __block id mockUserController;
    __block id mockPersistenceController;

    beforeEach(^{
        mockUserController = mock([UserController class]);
        id mockApplicationController = mock([ApplicationController class]);
        mockPersistenceController = mock([PersistenceController class]);

        [given([mockApplicationController userController]) willReturn:mockUserController];
        [given([mockApplicationController persistenceController]) willReturn:mockPersistenceController];

        sut = [[RootFlowViewController alloc] initWithApplicationController:mockApplicationController];
    });

    afterEach(^{
        sut = nil;
    });

    describe(@"view", ^{

        __block ContainerView *view;

        action(^{
            view = (ContainerView *) [sut view];
        });

        it(@"should be a container view", ^{
            expect(view).to.beKindOf([ContainerView class]);
        });

        describe(@"view controller presenter", ^{

            __block NavigationViewControllerPresenter *viewControllerPresenter;

            action(^{
                viewControllerPresenter = sut.viewControllerPresenter;
            });

            it(@"should be a navigation view controller presenter", ^{
                expect(viewControllerPresenter).to.beKindOf([NavigationViewControllerPresenter class]);
            });

            it(@"should have the first child view controller as its presenting navigation controller", ^{
                expect(viewControllerPresenter.navigationController).to.equal(sut.childViewControllers.firstObject);
            });
        });

        describe(@"search view controller", ^{

            __block UISearchController *searchController;

            action(^{
                searchController = [sut userSearchController];
            });

            it(@"should be a search controller", ^{
                expect(searchController).to.beKindOf([UISearchController class]);
            });

            describe(@"search results view controller", ^{

                __block UsersViewController *searchResultsController;

                action(^{
                    searchResultsController = (UsersViewController *) [searchController searchResultsController];
                });

                it(@"should be a search users controller", ^{
                    expect(searchResultsController).to.beKindOf([UsersViewController class]);
                });

                it(@"should have a delegate", ^{
                    expect(searchResultsController.delegate).to.equal(sut);
                });

                describe(@"users provider", ^{

                    __block SearchUsersProvider *usersProvider;

                    action(^{
                        usersProvider = (SearchUsersProvider *) [searchResultsController usersProvider];
                    });

                    it(@"should be a search users provider", ^{
                        expect(usersProvider).to.beKindOf([SearchUsersProvider class]);
                    });

                    it(@"should have the persistence controller", ^{
                        expect(usersProvider.persistenceController).to.equal(mockPersistenceController);
                    });

                    it(@"should be the search controller results updater", ^{
                        expect(searchController.searchResultsUpdater).to.equal(usersProvider);
                    });
                });
            });
        });

        describe(@"child view controllers", ^{

            __block NSArray *childViewControllers;

            action(^{
                childViewControllers = [sut childViewControllers];
            });

            it(@"should have one child view controller", ^{
                expect(childViewControllers).to.haveCountOf(1);
            });

            describe(@"first child view controller", ^{

                __block UINavigationController *childViewController;
                
                action(^{
                    childViewController = [childViewControllers firstObject];
                });

                it(@"should be a navigation controller", ^{
                    expect(childViewController).to.beKindOf([UINavigationController class]);
                });

                it(@"should set the child view controllers view as its contained view", ^{
                    expect(view.containedView).to.equal(childViewController.view);
                });
                
                describe(@"top view controller", ^{

                    __block UsersViewController *usersViewController;
                    
                    action(^{
                        usersViewController = (UsersViewController *) [childViewController topViewController];
                    });

                    it(@"should be a users view controller", ^{
                        expect(usersViewController).to.beKindOf([UsersViewController class]);
                    });

                    it(@"should have a delegate", ^{
                        expect(usersViewController.delegate).to.equal(sut);
                    });

                    describe(@"users provider", ^{

                        __block AllUsersProvider *usersProvider;

                        action(^{
                            usersProvider = (id) [usersViewController usersProvider];
                        });

                        it(@"should be a all users provider", ^{
                            expect(usersProvider).to.beKindOf([AllUsersProvider class]);
                        });

                        it(@"should have the user controller from application controller", ^{
                            expect(usersProvider.userController).to.equal(mockUserController);
                        });
                    });
                });
            });
        });
    });

    describe(@"users view controller delegate", ^{
        
        IN_MEMORY_CORE_DATA

        __block User *user;
        __block id mockViewControllerPresenter;

        beforeEach(^{
            user = [User specsEmptyObject];

            mockViewControllerPresenter = mockProtocol(@protocol(ViewControllerPresenter));
            sut.viewControllerPresenter = mockViewControllerPresenter;
        });

        action(^{
            [sut usersViewController:nil didSelectUser:user];
        });

        describe(@"last presented view controller", ^{

            __block AlbumsViewController *albumsViewController;

            action(^{
                HCArgumentCaptor *argumentCaptor = [HCArgumentCaptor new];
                [verify(mockViewControllerPresenter) pushViewController:(id) argumentCaptor
                                                               animated:YES
                                                             completion:nil];
                albumsViewController = [argumentCaptor value];
            });

            it(@"should be an albums view controller", ^{
                expect(albumsViewController).to.beKindOf([AlbumsViewController class]);
            });

            it(@"should have a delegate", ^{
                expect(albumsViewController.delegate).to.equal(sut);
            });

            describe(@"albums provider", ^{

                __block UserAlbumsProvider *albumsProvider;

                action(^{
                    albumsProvider = [albumsViewController albumsProvider];
                });

                it(@"should be a user albums provider", ^{
                    expect(albumsProvider).to.beKindOf([UserAlbumsProvider class]);
                });

                it(@"should have the passed in user", ^{
                    expect(albumsProvider.user).to.equal(user);
                });
            });
        });
    });

    describe(@"albums view controller delegate", ^{

        IN_MEMORY_CORE_DATA

        __block Album *album;
        __block id mockViewControllerPresenter;

        beforeEach(^{
            album = [Album specsEmptyObject];

            mockViewControllerPresenter = mockProtocol(@protocol(ViewControllerPresenter));
            sut.viewControllerPresenter = mockViewControllerPresenter;
        });

        action(^{
            [sut albumsViewController:nil didSelectAlbum:album];
        });

        describe(@"last presented view controller", ^{

            __block AlbumPhotosViewController *albumPhotosViewController;

            action(^{
                HCArgumentCaptor *argumentCaptor = [HCArgumentCaptor new];
                [verify(mockViewControllerPresenter) pushViewController:(id) argumentCaptor
                                                               animated:YES
                                                             completion:nil];
                albumPhotosViewController = [argumentCaptor value];
            });

            it(@"should be an albums view controller", ^{
                expect(albumPhotosViewController).to.beKindOf([AlbumPhotosViewController class]);
            });
        });
    });
});

SpecEnd
