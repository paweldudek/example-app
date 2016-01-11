#import "Specs.h"

#import "AllUsersProvider.h"
#import "UserController.h"
#import "PersistenceController.h"

SpecBegin(AllUsersProvider)

describe(@"AllUsersProvider", ^{

    __block AllUsersProvider *sut;
    __block id mockUserController;
    __block id mockPersistenceController;

    beforeEach(^{
        mockUserController = mock([UserController class]);
        mockPersistenceController = mock([PersistenceController class]);

        sut = [[AllUsersProvider alloc] initWithUserController:mockUserController
                                         persistenceController:mockPersistenceController];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have a title", ^{
        expect(sut.title).to.equal(@"Users");
    });

    describe(@"update content", ^{

        __block id mockDelegate;

        beforeEach(^{
            mockDelegate = mockProtocol(@protocol(ContentProviderDelegate));
            sut.delegate = mockDelegate;
        });

        action(^{
            [sut updateContent];
        });

        it(@"should tell its delegate that it will begin updating data", ^{
            [verify(mockDelegate) contentProviderWillBeginUpdatingData:sut];
        });

        it(@"should tell its users controller to update users", ^{
            [verify(mockUserController) updateUsersWithCompletion:anything()];
        });

        describe(@"when updating finishes", ^{

            action(^{
                HCArgumentCaptor *captor = [HCArgumentCaptor new];
                [verify(mockUserController) updateUsersWithCompletion:(id) captor];

                void (^completion)() = [captor value];
                if (completion) {
                    completion();
                }
            });

            it(@"should inform its delegate that it updated content", ^{
                [verify(mockDelegate) contentProviderDidUpdateContent:sut];
            });

            it(@"should tell its delegate that it finished loading data", ^{
                [verify(mockDelegate) contentProviderDidFinishUpdatingData:sut];
            });
        });
    });
});

SpecEnd
