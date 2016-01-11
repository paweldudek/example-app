#import "Specs.h"

#import "AlbumsViewController.h"

SpecBegin(AlbumsViewController)

describe(@"AlbumsViewController", ^{

    __block AlbumsViewController *sut;

    __block id mockAlbumsProvider;

    beforeEach(^{
        mockAlbumsProvider = mockProtocol(@protocol(AlbumsProvider));
        sut = [[AlbumsViewController alloc] initWithAlbumsProvider:mockAlbumsProvider];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should set itself as delegate of the albums provider", ^{
        [verify(mockAlbumsProvider) setDelegate:sut];
    });

    describe(@"view", ^{

        action(^{
            [sut loadViewIfNeeded];
        });

        it(@"should tell the albums provider to update content", ^{
            [verify(mockAlbumsProvider) updateContent];
        });

    });
});

SpecEnd
