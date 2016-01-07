#import "Specs.h"

#import "PersistenceController.h"

SpecBegin(PersistenceController)

describe(@"PersistenceController", ^{

    __block PersistenceController *sut;

    beforeEach(^{
        sut = [[PersistenceController alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    describe(@"", ^{

    });
});

SpecEnd
