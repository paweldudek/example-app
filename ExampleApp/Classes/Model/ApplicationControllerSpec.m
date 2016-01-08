#import "Specs.h"

#import "ApplicationController.h"
#import "UserController.h"

SpecBegin(ApplicationController)

describe(@"ApplicationController", ^{

    __block ApplicationController *sut;

    beforeEach(^{
        sut = [[ApplicationController alloc] initWithPersistenceController:nil];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have a user controller", ^{
        expect(sut.userController).to.beKindOf([UserController class]);
    });
});

SpecEnd
