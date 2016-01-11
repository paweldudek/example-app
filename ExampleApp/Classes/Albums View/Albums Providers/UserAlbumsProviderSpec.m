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

        action(^{
            [sut updateContent];
        });

        it(@"should tell its album updater to update albums", ^{
            [verify(mockAlbumController) updateAlbumsWithCompletion:anything()];
        });
    });

});

SpecEnd
