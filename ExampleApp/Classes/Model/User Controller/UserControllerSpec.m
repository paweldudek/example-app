#import "Specs.h"

#import "UserController.h"
#import "UpdateUsersOperation.h"
#import "PersistenceController.h"

SpecBegin(UserController)

describe(@"UserController", ^{

    __block UserController *sut;
    __block id mockPersistenceController;

    beforeEach(^{
        mockPersistenceController = mock([PersistenceController class]);

        sut = [[UserController alloc] initWithPersistenceController:mockPersistenceController];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have an operation queue", ^{
        expect(sut.operationQueue).to.beKindOf([NSOperationQueue class]);
    });

    describe(@"update users", ^{

        __block NSError *capturedError;
        __block id mockOperationQueue;

        beforeEach(^{
            mockOperationQueue = mock([NSOperationQueue class]);
            sut.operationQueue = mockOperationQueue;
        });

        action(^{
            [sut updateUsersWithCompletion:^(NSError *error) {
                capturedError = error;
            }];
        });

        describe(@"last operation", ^{

            __block UpdateUsersOperation *operation;

            action(^{
                HCArgumentCaptor *captor = [HCArgumentCaptor new];
                [verify(mockOperationQueue) addOperation:(id) captor];

                operation = [captor value];
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
