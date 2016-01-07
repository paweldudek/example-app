#import "Specs.h"

#import "AppDelegate.h"
#import "RootFlowViewController.h"
#import "PersistenceController.h"

SpecBegin(AppDelegate)

describe(@"AppDelegate", ^{

    __block AppDelegate *sut;

    beforeEach(^{
        sut = [[AppDelegate alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have a persistence controller", ^{
        expect(sut.persistenceController).to.beKindOf([PersistenceController class]);
    });

    describe(@"application did finish launching", ^{

        action(^{
            [sut application:mock([UIApplication class]) didFinishLaunchingWithOptions:nil];
        });

        describe(@"root view controller", ^{

            __block RootFlowViewController *rootViewController;

            action(^{
                rootViewController = (RootFlowViewController *) [sut.window rootViewController];
            });

            it(@"should be a root flow view controller", ^{
                expect(rootViewController).to.beKindOf([RootFlowViewController class]);
            });

            describe(@"application controller", ^{

                action(^{

                });

                it(@"should have the persistence controller", ^{
                    expect(NO).to.beTruthy();
                });
            });
        });
    });
});

SpecEnd
