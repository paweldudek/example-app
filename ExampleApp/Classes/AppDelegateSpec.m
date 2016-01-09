#import "Specs.h"

#import "AppDelegate.h"
#import "RootFlowViewController.h"
#import "PersistenceController.h"
#import "ApplicationController.h"
#import "NSFileManager+ExampleApp.h"

SpecBegin(AppDelegate)

describe(@"AppDelegate", ^{

    __block AppDelegate *sut;

    beforeEach(^{
        sut = [[AppDelegate alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    describe(@"persistence controller", ^{

        __block PersistenceController *persistenceController;

        action(^{
            persistenceController = [sut persistenceController];
        });

        it(@"should be a persistence controller", ^{
            expect(persistenceController).to.beKindOf([PersistenceController class]);
        });

        it(@"should have an url", ^{
            NSURL *coreDataURL = [[[NSFileManager defaultManager] applicationSupportDirectoryURL] URLByAppendingPathComponent:@"CoreData"];
            expect(persistenceController.coreDataStackFolderURL).to.equal(coreDataURL);
        });
    });

    describe(@"application did finish launching", ^{

        __block id mockWindow;
        __block id mockPersistenceController;

        beforeEach(^{
            mockWindow = mock([UIWindow class]);
            sut.window = mockWindow;

            mockPersistenceController = mock([PersistenceController class]);
            sut.persistenceController = mockPersistenceController;
        });

        action(^{
            [sut application:mock([UIApplication class]) didFinishLaunchingWithOptions:nil];
        });

        it(@"should tell the window to become key and visible", ^{
            [verify(mockWindow) makeKeyAndVisible];
        });

        it(@"should tell its persistence controller to setup core data stack", ^{
            [verify(mockPersistenceController) setupCoreDataStack];
        });

        describe(@"root view controller", ^{

            __block RootFlowViewController *rootViewController;

            action(^{
                HCArgumentCaptor *argumentCaptor = [HCArgumentCaptor new];
                [verify(mockWindow) setRootViewController:(id) argumentCaptor];
                rootViewController = [argumentCaptor value];
            });

            it(@"should be a root flow view controller", ^{
                expect(rootViewController).to.beKindOf([RootFlowViewController class]);
            });

            describe(@"application controller", ^{

                __block ApplicationController *applicationController;

                action(^{
                    applicationController = [rootViewController applicationController];
                });

                it(@"should be an application controller", ^{
                    expect(applicationController).to.beKindOf([ApplicationController class]);
                });

                it(@"should have the persistence controller", ^{
                    expect(applicationController.persistenceController).to.equal(mockPersistenceController);
                });
            });
        });
    });
});

SpecEnd
