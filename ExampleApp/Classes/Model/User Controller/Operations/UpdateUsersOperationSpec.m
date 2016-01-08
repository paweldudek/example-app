#import "Specs.h"

#import "UpdateUsersOperation.h"
#import "UsersUpdater.h"

SpecBegin(UpdateUsersOperation)

describe(@"UpdateUsersOperation", ^{

    __block UpdateUsersOperation *sut;

    beforeEach(^{
        sut = [[UpdateUsersOperation alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have users updater", ^{
        expect(sut.usersUpdater).to.beKindOf([UsersUpdater class]);
    });

    describe(@"run", ^{

        action(^{
            [sut start];
        });

    });
});

SpecEnd
