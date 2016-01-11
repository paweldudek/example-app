#import "Specs.h"

#import "UserAlbumsProvider.h"
#import "NSManagedObject+SpecHelpers.h"
#import "User.h"
#import "AlbumController.h"
#import "PersistenceController.h"

SpecBegin(UserAlbumsProvider)

describe(@"UserAlbumsProvider", ^{

    IN_MEMORY_CORE_DATA

    __block UserAlbumsProvider *sut;
    __block User *user;

    __block id mockAlbumController;
    __block id mockPersistenceController;

    beforeEach(^{
        mockAlbumController = mock([AlbumController class]);
        mockPersistenceController = mock([PersistenceController class]);

        [given([mockPersistenceController mainThreadManagedObjectContext]) willReturn:[NSManagedObjectContext specsManagedObjectContext]];

        user = [User specsEmptyObject];
        user.name = @"Fixture Username";

        sut = [[UserAlbumsProvider alloc] initWithUser:user
                                       albumController:mockAlbumController
                                 persistenceController:mockPersistenceController];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have a title equal to user name", ^{
        expect(sut.title).to.equal(@"Fixture Username");
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
            [verify(mockAlbumController) updateAlbumsWithCompletion:anything()];
        });

        describe(@"when updating finishes", ^{

            action(^{
                HCArgumentCaptor *captor = [HCArgumentCaptor new];
                [verify(mockAlbumController) updateAlbumsWithCompletion:(id) captor];

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
