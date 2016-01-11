#import "Specs.h"

#import "ApplicationController.h"
#import "UserController.h"
#import "PersistenceController.h"
#import "AlbumController.h"

SpecBegin(ApplicationController)

describe(@"ApplicationController", ^{

    __block ApplicationController *sut;
    __block id mockPersistenceController;

    beforeEach(^{
        mockPersistenceController = mock([PersistenceController class]);

        sut = [[ApplicationController alloc] initWithPersistenceController:mockPersistenceController];
    });

    afterEach(^{
        sut = nil;
    });

    describe(@"user controller", ^{

        __block UserController *userController;

        action(^{
            userController = [sut userController];
        });

        it(@"should have a user controller", ^{
            expect(userController).to.beKindOf([UserController class]);
        });

        it(@"should have the persistence controller", ^{
            expect(userController.persistenceController).to.equal(mockPersistenceController);
        });
    });

    describe(@"album controller", ^{

        __block AlbumController *albumController;

        action(^{
            albumController = [sut albumController];
        });

        it(@"should have a user controller", ^{
            expect(albumController).to.beKindOf([AlbumController class]);
        });

        it(@"should have the persistence controller", ^{
            expect(albumController.persistenceController).to.equal(mockPersistenceController);
        });
    });
});

SpecEnd
