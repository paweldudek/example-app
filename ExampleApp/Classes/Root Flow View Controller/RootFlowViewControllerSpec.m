#import "Specs.h"

#import "RootFlowViewController.h"
#import "ContainerView.h"
#import "AllUsersProvider.h"
#import "ViewControllerPresenter.h"
#import "NavigationViewControllerPresenter.h"
#import "NSManagedObject+SpecHelpers.h"
#import "User.h"
#import "Album.h"
#import "ApplicationController.h"
#import "UserController.h"
#import "UserAlbumsProvider.h"
#import "SearchUsersProvider.h"
#import "PersistenceController.h"
#import "AlbumController.h"
#import "AlbumPhotosProvider.h"

SpecBegin(RootFlowViewController)

describe(@"RootFlowViewController", ^{

    __block RootFlowViewController *sut;

    __block id mockUserController;
    __block id mockAlbumController;
    __block id mockPersistenceController;

    beforeEach(^{
        mockUserController = mock([UserController class]);
        id mockApplicationController = mock([ApplicationController class]);
        mockPersistenceController = mock([PersistenceController class]);
        mockAlbumController = mock([AlbumController class]);

        [given([mockApplicationController userController]) willReturn:mockUserController];
        [given([mockApplicationController persistenceController]) willReturn:mockPersistenceController];
        [given([mockApplicationController albumController]) willReturn:mockAlbumController];

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

                __block TableContentViewController *searchResultsController;

                action(^{
                    searchResultsController = (TableContentViewController *) [searchController searchResultsController];
                });

                it(@"should be a search users controller", ^{
                    expect(searchResultsController).to.beKindOf([TableContentViewController class]);
                });

                describe(@"presentation controller", ^{

                    __block UserPresentationController *tableContentPresentationController;

                    action(^{
                        tableContentPresentationController = (id) [searchResultsController tableContentPresentationController];
                    });

                    it(@"should be user presentation controller", ^{
                        expect(tableContentPresentationController).to.beKindOf([UserPresentationController class]);
                    });

                    it(@"should have a delegate", ^{
                        expect(tableContentPresentationController.delegate).to.equal(sut);
                    });
                });

                describe(@"users provider", ^{

                    __block SearchUsersProvider *contentProvider;

                    action(^{
                        contentProvider = (SearchUsersProvider *) [searchResultsController contentProvider];
                    });

                    it(@"should be a search users provider", ^{
                        expect(contentProvider).to.beKindOf([SearchUsersProvider class]);
                    });

                    it(@"should have the persistence controller", ^{
                        expect(contentProvider.persistenceController).to.equal(mockPersistenceController);
                    });

                    it(@"should be the search controller results updater", ^{
                        expect(searchController.searchResultsUpdater).to.equal(contentProvider);
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

                    __block TableContentViewController *usersViewController;
                    
                    action(^{
                        usersViewController = (TableContentViewController *) [childViewController topViewController];
                    });

                    it(@"should be a users view controller", ^{
                        expect(usersViewController).to.beKindOf([TableContentViewController class]);
                    });

                    describe(@"presentation controller", ^{

                        __block UserPresentationController *tableContentPresentationController;

                        action(^{
                            tableContentPresentationController = (id) [usersViewController tableContentPresentationController];
                        });

                        it(@"should be user presentation controller", ^{
                            expect(tableContentPresentationController).to.beKindOf([UserPresentationController class]);
                        });

                        it(@"should have a delegate", ^{
                            expect(tableContentPresentationController.delegate).to.equal(sut);
                        });
                    });

                    describe(@"users provider", ^{

                        __block AllUsersProvider *contentProvider;

                        action(^{
                            contentProvider = (id) [usersViewController contentProvider];
                        });

                        it(@"should be a all users provider", ^{
                            expect(contentProvider).to.beKindOf([AllUsersProvider class]);
                        });

                        it(@"should have the user controller from application controller", ^{
                            expect(contentProvider.userController).to.equal(mockUserController);
                        });

                        it(@"should have the persistence controller from application controller", ^{
                            expect(contentProvider.persistenceController).to.equal(mockPersistenceController);
                        });
                    });
                });
            });
        });
    });

    describe(@"users presentation controller delegate", ^{
        
        IN_MEMORY_CORE_DATA

        __block User *user;
        __block id mockViewControllerPresenter;

        beforeEach(^{
            user = [User specsEmptyObject];

            mockViewControllerPresenter = mockProtocol(@protocol(ViewControllerPresenter));
            sut.viewControllerPresenter = mockViewControllerPresenter;
        });

        action(^{
            [sut userPresentationController:nil didSelectUser:user];
        });

        describe(@"last presented view controller", ^{

            __block TableContentViewController *albumsViewController;

            action(^{
                HCArgumentCaptor *argumentCaptor = [HCArgumentCaptor new];
                [verify(mockViewControllerPresenter) pushViewController:(id) argumentCaptor
                                                               animated:YES
                                                             completion:nil];
                albumsViewController = [argumentCaptor value];
            });

            it(@"should be an albums view controller", ^{
                expect(albumsViewController).to.beKindOf([TableContentViewController class]);
            });

            describe(@"presentation controller", ^{

                __block AlbumPresentationController *tableContentPresentationController;

                action(^{
                    tableContentPresentationController = (id) [albumsViewController tableContentPresentationController];
                });

                it(@"should be user presentation controller", ^{
                    expect(tableContentPresentationController).to.beKindOf([AlbumPresentationController class]);
                });

                it(@"should have a delegate", ^{
                    expect(tableContentPresentationController.delegate).to.equal(sut);
                });
            });

            describe(@"albums provider", ^{

                __block UserAlbumsProvider *contentProvider;

                action(^{
                    contentProvider = [albumsViewController contentProvider];
                });

                it(@"should be a user albums provider", ^{
                    expect(contentProvider).to.beKindOf([UserAlbumsProvider class]);
                });

                it(@"should have the passed in user", ^{
                    expect(contentProvider.user).to.equal(user);
                });

                it(@"should have a persistence controller", ^{
                    expect(contentProvider.persistenceController).to.equal(mockPersistenceController);
                });

                it(@"should have album controller", ^{
                    expect(contentProvider.albumController).to.equal(mockAlbumController);
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
            [sut albumPresentationController:nil didSelectAlbum:album];
        });
        describe(@"last presented view controller", ^{

            __block TableContentViewController *albumsViewController;

            action(^{
                HCArgumentCaptor *argumentCaptor = [HCArgumentCaptor new];
                [verify(mockViewControllerPresenter) pushViewController:(id) argumentCaptor
                                                               animated:YES
                                                             completion:nil];
                albumsViewController = [argumentCaptor value];
            });

            it(@"should be an table content view controller", ^{
                expect(albumsViewController).to.beKindOf([TableContentViewController class]);
            });

            describe(@"presentation controller", ^{

                __block AlbumPresentationController *tableContentPresentationController;

                action(^{
                    tableContentPresentationController = (id) [albumsViewController tableContentPresentationController];
                });

                it(@"should be user presentation controller", ^{
                    expect(tableContentPresentationController).to.beKindOf([AlbumPresentationController class]);
                });

                it(@"should have a delegate", ^{
                    expect(tableContentPresentationController.delegate).to.equal(sut);
                });
            });

            describe(@"albums provider", ^{

                __block AlbumPhotosProvider *contentProvider;

                action(^{
                    contentProvider = [albumsViewController contentProvider];
                });

                it(@"should be a user albums provider", ^{
                    expect(contentProvider).to.beKindOf([AlbumPhotosProvider class]);
                });

                it(@"should have the passed in user", ^{
                    expect(contentProvider.album).to.equal(album);
                });

                it(@"should have a persistence controller", ^{
                    expect(contentProvider.persistenceController).to.equal(mockPersistenceController);
                });

                it(@"should have album controller", ^{
                    expect(contentProvider.albumController).to.equal(mockAlbumController);
                });
            });
        });
    });
});

SpecEnd
