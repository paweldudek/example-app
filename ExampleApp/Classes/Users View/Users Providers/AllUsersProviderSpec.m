#import "Specs.h"

#import "AllUsersProvider.h"
#import "UserController.h"

SpecBegin(AllUsersProvider)

describe(@"AllUsersProvider", ^{

    __block AllUsersProvider *sut;
    __block id mockUserController;

    beforeEach(^{
        mockUserController = mock([UserController class]);

        sut = [[AllUsersProvider alloc] initWithUserController:mockUserController];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have a title", ^{
        expect(sut.title).to.equal(@"Users");
    });

    it(@"should have a persistence controller", ^{
        expect(NO).to.beTruthy();
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

            });

            it(@"should tell its delegate that it finished loading data", ^{
                [verify(mockDelegate) contentProviderDidFinishUpdatingData:sut];
            });
        });
    });
});

SpecEnd
