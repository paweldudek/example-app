#import "Specs.h"

#import "UserAlbumsProvider.h"
#import "NSManagedObject+SpecHelpers.h"
#import "User.h"

SpecBegin(UserAlbumsProvider)

describe(@"UserAlbumsProvider", ^{

    IN_MEMORY_CORE_DATA

    __block UserAlbumsProvider *sut;
    __block User *user;

    beforeEach(^{
        user = [User specsEmptyObject];
        user.name = @"Fixture Username";
        sut = [[UserAlbumsProvider alloc] initWithUser:user];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have a title equal to user name", ^{
        expect(sut.title).to.equal(@"Fixture Username");
    });

    describe(@"", ^{
        
    });
});

SpecEnd
