#import "Specs.h"

#import "AlbumsNetworkLayerRequest.h"

SpecBegin(AlbumsNetworkLayerRequest)

describe(@"AlbumsNetworkLayerRequest", ^{

    __block AlbumsNetworkLayerRequest *sut;

    beforeEach(^{
        sut = [[AlbumsNetworkLayerRequest alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have an endpoint", ^{
        expect(sut.endpoint).to.equal(@"albums");
    });
});

SpecEnd
