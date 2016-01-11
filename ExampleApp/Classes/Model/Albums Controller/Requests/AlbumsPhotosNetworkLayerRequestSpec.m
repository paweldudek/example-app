#import "Specs.h"

#import "AlbumsPhotosNetworkLayerRequest.h"

SpecBegin(AlbumsPhotosNetworkLayerRequest)

describe(@"AlbumsPhotosNetworkLayerRequest", ^{

    __block AlbumsPhotosNetworkLayerRequest *sut;

    beforeEach(^{
        sut = [[AlbumsPhotosNetworkLayerRequest alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have an endpoint", ^{
        expect(sut.endpoint).to.equal(@"photos");
    });
});

SpecEnd
