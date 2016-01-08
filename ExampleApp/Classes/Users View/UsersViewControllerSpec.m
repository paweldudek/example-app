#import "Specs.h"

#import "UsersViewController.h"

SpecBegin(UsersViewController)

describe(@"UsersViewController", ^{

    __block UsersViewController *sut;

    __block id mockUsersProvider;

    beforeEach(^{
        mockUsersProvider = mockProtocol(@protocol(UsersProvider));
        sut = [[UsersViewController alloc] initWithUsersProvider:mockUsersProvider];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should set itself as delegate of the users provider", ^{
        [verify(mockUsersProvider) setDelegate:sut];
    });

    describe(@"view", ^{

        action(^{
            [sut view];
        });

        it(@"should tell its users provider to update content", ^{
            [verify(mockUsersProvider) updateContent];
        });
    });
});

SpecEnd
