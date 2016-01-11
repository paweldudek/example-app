#import "Specs.h"

#import "UsersNetworkLayerRequest.h"

SpecBegin(UsersNetworkLayerRequest)

describe(@"UsersNetworkLayerRequest", ^{

    __block UsersNetworkLayerRequest *sut;

    beforeEach(^{
        sut = [[UsersNetworkLayerRequest alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have an endpoint", ^{
        expect(sut.endpoint).to.equal(@"users");
    });
});

SpecEnd
