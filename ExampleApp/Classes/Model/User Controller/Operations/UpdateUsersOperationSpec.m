#import "Specs.h"

#import "UpdateUsersOperation.h"
#import "UsersUpdater.h"
#import "NetworkLayerExampleAppSharedSpec.h"
#import "PersistenceController.h"
#import "NSManagedObjectContext+SpecHelpers.h"
#import "FakeOperationQueue.h"
#import "NetworkLayer.h"
#import "UsersNetworkLayerRequest.h"

SpecBegin(UpdateUsersOperation)

describe(@"UpdateUsersOperation", ^{

    __block UpdateUsersOperation *sut;
    __block id mockPersistenceController;

    IN_MEMORY_CORE_DATA

    beforeEach(^{
        mockPersistenceController = mock([PersistenceController class]);
        [given([mockPersistenceController mainThreadManagedObjectContext]) willReturn:[NSManagedObjectContext specsManagedObjectContext]];

        sut = [[UpdateUsersOperation alloc] initWithPersistenceController:mockPersistenceController];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have users updater", ^{
        expect(sut.usersUpdater).to.beKindOf([UsersUpdater class]);
    });

    it(@"should have a completion queue", ^{
        expect(sut.completionQueue).to.equal([NSOperationQueue mainQueue]);
    });

    describe(@"network layer", ^{

        __block NetworkLayer *networkLayer;

        action(^{
            networkLayer = [sut networkLayer];
        });

        itShouldBehaveLikeExampleAppNetworkLayer(networkLayer);
    });

    describe(@"run", ^{

        __block id mockNetworkLayer;
        __block id requestIdentifier;

        __block FakeOperationQueue *fakeCompletionQueue;

        beforeEach(^{
            requestIdentifier = [NSObject new];

            mockNetworkLayer = mock([NetworkLayer class]);
            sut.networkLayer = mockNetworkLayer;

            [given([mockNetworkLayer makeRequest:anything()
                                      completion:anything()]) willReturn:requestIdentifier];

            fakeCompletionQueue = [FakeOperationQueue new];
            sut.completionQueue = fakeCompletionQueue;
        });

        action(^{
            [sut start];
        });

        describe(@"last request", ^{

            __block UsersNetworkLayerRequest *request;
            __block NetworkLayerRequestCompletion completion;

            action(^{
                HCArgumentCaptor *requestCaptor = [HCArgumentCaptor new];
                HCArgumentCaptor *completionCaptor = [HCArgumentCaptor new];

                [verify(mockNetworkLayer) makeRequest:(id) requestCaptor completion:(id) completionCaptor];

                request = [requestCaptor value];
                completion = [completionCaptor value];
            });

            it(@"should make a user network layer request", ^{
                expect(request).to.beKindOf([UsersNetworkLayerRequest class]);
            });

            describe(@"when it is successful", ^{

                __block NSArray *usersResponse;
                __block PersistenceControllerSaveCompletion saveCompletion;

                __block id mockUsersUpdater;

                __block NSManagedObjectContext *privateManagedObjectContext;

                beforeEach(^{
                    usersResponse = @[@{@"Fixture User Key 1" : @"Fixture User Key 1"}, @{@"Fixture User Key 2" : @"Fixture User Key 2"}];

                    mockUsersUpdater = mock([UsersUpdater class]);
                    sut.usersUpdater = mockUsersUpdater;
                });

                action(^{
                    NSData *data = [NSJSONSerialization dataWithJSONObject:usersResponse options:0 error:nil];
                    if (completion) {
                        completion(data, nil, nil);
                    }

                    HCArgumentCaptor *managedObjectContextCaptor = [HCArgumentCaptor new];
                    HCArgumentCaptor *saveCompletionCaptor = [HCArgumentCaptor new];

                    [verify(mockPersistenceController) saveChildContext:(id) managedObjectContextCaptor
                                                             completion:(id) saveCompletionCaptor];
                    saveCompletion = [saveCompletionCaptor value];

                    privateManagedObjectContext = [managedObjectContextCaptor value];
                });

                it(@"should tell the questions updater to update questions", ^{
                    [verify(mockUsersUpdater) updateUsersWithResponse:usersResponse
                                                 managedObjectContext:privateManagedObjectContext];
                });

                describe(@"when save is successful", ^{

                    __block BOOL completionCalled;
                    __block NSError *capturedError;

                    beforeEach(^{
                        sut.updateCompletion = ^(NSError *error) {
                            completionCalled = YES;
                            capturedError = error;
                        };
                    });

                    action(^{
                        saveCompletion(YES, nil);
                        [fakeCompletionQueue runLastBlockOperation];
                    });

                    afterEach(^{
                        completionCalled = NO;
                    });

                    it(@"should call the completion bloc", ^{
                        expect(completionCalled).to.beTruthy();
                    });

                    it(@"should call the completion block without any error", ^{
                        expect(capturedError).to.beNil();
                    });
                });

                describe(@"when save fails", ^{

                    __block NSError *error;
                    __block BOOL completionCalled;
                    __block NSError *capturedError;

                    beforeEach(^{
                        sut.updateCompletion = ^(NSError *completionError) {
                            completionCalled = YES;
                            capturedError = completionError;
                        };
                        error = [NSError errorWithDomain:@"Fixture Domain" code:42 userInfo:nil];
                    });

                    action(^{
                        saveCompletion(NO, error);
                        [fakeCompletionQueue runLastBlockOperation];
                    });

                    afterEach(^{
                        completionCalled = NO;
                    });

                    it(@"should call the completion bloc", ^{
                        expect(completionCalled).to.beTruthy();
                    });

                    it(@"should call the completion block with save any error", ^{
                        expect(capturedError).to.equal(error);
                    });
                });
            });

            describe(@"when it fails", ^{

                __block NSError *error;

                __block BOOL completionCalled;
                __block NSError *capturedError;

                beforeEach(^{
                    sut.updateCompletion = ^(NSError *completionError) {
                        completionCalled = YES;
                        capturedError = completionError;
                    };
                });

                beforeEach(^{
                    error = [NSError errorWithDomain:@"Fixture Domain" code:42 userInfo:nil];
                });

                action(^{
                    if (completion) {
                        completion(nil, nil, error);
                    }
                    [fakeCompletionQueue runLastBlockOperation];
                });

                afterEach(^{
                    completionCalled = NO;
                });

                it(@"should call the completion block", ^{
                    expect(completionCalled).to.beTruthy();
                });

                it(@"should call the completion block with save any error", ^{
                    expect(capturedError).to.equal(error);
                });
            });
        });

        describe(@"when it is cancelled", ^{

            action(^{
                [sut cancel];
            });

            it(@"should cancel ongoing request", ^{
                [verify(mockNetworkLayer) cancelRequestWithIdentifier:requestIdentifier];
            });
        });
    });
});

SpecEnd
