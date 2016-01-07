#import "Specs.h"

#import "NavigationViewControllerPresenter.h"
#import "HCArgumentCaptor.h"

SpecBegin(NavigationViewControllerPresenter)

describe(@"NavigationViewControllerPresenter", ^{

    __block NavigationViewControllerPresenter *sut;

    __block id mockNavigationController;

    beforeEach(^{
        mockNavigationController = mock([UINavigationController class]);
        sut = [[NavigationViewControllerPresenter alloc] initWithNavigationController:mockNavigationController];
    });

    afterEach(^{
        sut = nil;
    });

    describe(@"push view controller animated", ^{

        __block id mockViewController;
        __block BOOL completionCalled;

        beforeEach(^{
            mockViewController = mock([UIViewController class]);
            completionCalled = NO;
        });

        action(^{
            [sut pushViewController:mockViewController animated:YES completion:^{
                completionCalled = YES;
            }];
        });

        it(@"should push that view controller onto navigation controller", ^{
            [verify(mockNavigationController) pushViewController:mockViewController animated:YES];
        });

        describe(@"once the transition finishes", ^{

            __block id mockTransitionCoordinator;

            beforeEach(^{
                mockTransitionCoordinator = mockProtocol(@protocol(UIViewControllerTransitionCoordinator));
                [given([mockViewController transitionCoordinator]) willReturn:mockTransitionCoordinator];
            });

            action(^{
                HCArgumentCaptor *captor = [HCArgumentCaptor new];
                [verify(mockTransitionCoordinator) animateAlongsideTransition:nil
                                                                   completion:(id) captor];

                void (^completion)(id <UIViewControllerTransitionCoordinatorContext>) = [captor value];
                if (completion) {
                    completion(nil);
                }
            });

            it(@"should call the completion block", ^{
                expect(completionCalled).to.beTruthy();
            });
        });
    });
});

SpecEnd
