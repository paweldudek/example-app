#import "Specs.h"

#import "ApplicationController.h"
#import "UserController.h"
#import "PersistenceController.h"

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
            expect(sut.userController).to.beKindOf([UserController class]);
        });

        it(@"should have the persistence controller", ^{
            expect(sut.persistenceController).to.equal(mockPersistenceController);
        });
    });
});

SpecEnd
