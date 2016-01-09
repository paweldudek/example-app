#import "Specs.h"
#import "NetworkLayer.h"

SharedExamplesBegin(NetworkLayerExampleApp)

sharedExamplesFor(@"network layer example app backend", ^(NSDictionary *data) {

    __block NetworkLayer *networkLayer = nil;

    action(^{
        networkLayer = data[@"networkLayer"];
    });

    it(@"should be a network layer", ^{
        expect(networkLayer).to.beKindOf([NetworkLayer class]);
    });

    it(@"should have the correct backend URL", ^{
        expect(networkLayer.baseURL).to.equal([NSURL URLWithString:@"http://jsonplaceholder.typicode.com"]);
    });
});

SharedExamplesEnd
