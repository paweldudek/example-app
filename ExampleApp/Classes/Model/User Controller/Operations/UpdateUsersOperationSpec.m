#import "Specs.h"

#import "UpdateUsersOperation.h"
#import "UsersUpdater.h"
#import "NetworkLayerExampleAppSharedSpec.h"
#import "PersistenceController.h"
#import "NSManagedObjectContext+SpecHelpers.h"

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

    describe(@"network layer", ^{

        __block NetworkLayer *networkLayer;

        action(^{
            networkLayer = [sut networkLayer];
        });

        itShouldBehaveLikeExampleAppNetworkLayer(networkLayer);
    });

    describe(@"run", ^{

        action(^{
            [sut start];
        });

    });
});

SpecEnd
