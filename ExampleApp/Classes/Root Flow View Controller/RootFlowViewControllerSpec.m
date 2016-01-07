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

SpecBegin(RootFlowViewController)

describe(@"RootFlowViewController", ^{

    __block RootFlowViewController *sut;

    beforeEach(^{
        sut = [[RootFlowViewController alloc] init];
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

                        __block id <UsersProvider> usersProvider;

                        action(^{
                            usersProvider = [usersViewController usersProvider];
                        });

                        it(@"should be a all users provider", ^{
                            expect(usersProvider).to.beKindOf([AllUsersProvider class]);
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
        });
    });
});

SpecEnd
