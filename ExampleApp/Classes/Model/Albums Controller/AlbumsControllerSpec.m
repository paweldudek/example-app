#import "Specs.h"

#import "AlbumController.h"
#import "PersistenceController.h"
#import "GenericUpdateContentOperation.h"
#import "AlbumsUpdater.h"
#import "AlbumsNetworkLayerRequest.h"
#import "AlbumsPhotosNetworkLayerRequest.h"
#import "AlbumsPhotosUpdater.h"

SpecBegin(AlbumsController)

describe(@"AlbumController", ^{

    __block AlbumController *sut;
    __block id mockPersistenceController;

    beforeEach(^{
        mockPersistenceController = mock([PersistenceController class]);
        sut = [[AlbumController alloc] initWithPersistenceController:mockPersistenceController];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have an operation queue", ^{
        expect(sut.operationQueue).to.beKindOf([NSOperationQueue class]);
    });

    describe(@"update albums", ^{

            __block NSError *capturedError;
            __block id mockOperationQueue;

            beforeEach(^{
                mockOperationQueue = mock([NSOperationQueue class]);
                sut.operationQueue = mockOperationQueue;
            });

            action(^{
                [sut updateAlbumsWithCompletion:^(NSError *error) {
                    capturedError = error;
                }];
            });

            describe(@"last operation", ^{

                __block GenericUpdateContentOperation *operation;

                action(^{
                    HCArgumentCaptor *captor = [HCArgumentCaptor new];
                    [verify(mockOperationQueue) addOperation:(id) captor];

                    operation = [captor value];
                });

                it(@"should be albums update operation", ^{
                    expect(operation).to.beKindOf([GenericUpdateContentOperation class]);
                });

                it(@"should have albums network layer request", ^{
                    expect(operation.request).to.beKindOf([AlbumsNetworkLayerRequest class]);
                });

                it(@"should have albums updater", ^{
                    expect(operation.contentUpdater).to.beKindOf([AlbumsUpdater class]);
                });

                it(@"should have the persistence controller", ^{
                    expect(operation.persistenceController).to.equal(mockPersistenceController);
                });

                describe(@"when it completes", ^{

                    __block NSError *error;

                    beforeEach(^{
                        error = [NSError errorWithDomain:@"Fixture Domain" code:42 userInfo:nil];
                    });

                    action(^{
                        if (operation.updateCompletion) {
                            operation.updateCompletion(error);
                        }
                    });

                    it(@"should call the completion block", ^{
                        expect(capturedError).to.equal(error);
                    });
                });
            });
        });

    describe(@"update albums photos", ^{

        __block NSError *capturedError;
        __block id mockOperationQueue;

        beforeEach(^{
            mockOperationQueue = mock([NSOperationQueue class]);
            sut.operationQueue = mockOperationQueue;
        });

        action(^{
            [sut updateAlbumsPhotosWithCompletion:^(NSError *error) {
                capturedError = error;
            }];
        });

        describe(@"last operation", ^{

            __block GenericUpdateContentOperation *operation;

            action(^{
                HCArgumentCaptor *captor = [HCArgumentCaptor new];
                [verify(mockOperationQueue) addOperation:(id) captor];

                operation = [captor value];
            });

            it(@"should be albums update operation", ^{
                expect(operation).to.beKindOf([GenericUpdateContentOperation class]);
            });

            it(@"should have albums photos updater", ^{
                expect(operation.contentUpdater).to.beKindOf([AlbumsPhotosUpdater class]);
            });

            it(@"should have albums photos network layer request", ^{
                expect(operation.request).to.beKindOf([AlbumsPhotosNetworkLayerRequest class]);
            });

            it(@"should have the persistence controller", ^{
                expect(operation.persistenceController).to.equal(mockPersistenceController);
            });

            describe(@"when it completes", ^{

                __block NSError *error;

                beforeEach(^{
                    error = [NSError errorWithDomain:@"Fixture Domain" code:42 userInfo:nil];
                });

                action(^{
                    if (operation.updateCompletion) {
                        operation.updateCompletion(error);
                    }
                });

                it(@"should call the completion block", ^{
                    expect(capturedError).to.equal(error);
                });
            });
        });
    });
});

SpecEnd
