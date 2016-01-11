#import "Specs.h"

#import "SearchUsersProvider.h"

SpecBegin(SearchUsersProvider)

describe(@"SearchUsersProvider", ^{

    __block SearchUsersProvider *sut;

    beforeEach(^{
        sut = [[SearchUsersProvider alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have a title", ^{
        expect(sut.title).to.equal(@"Search");
    });

    describe(@"when the search controller updates", ^{

        __block id mockSearchController;

        __block id mockDelegate;

        beforeEach(^{
            mockSearchController = mock([UISearchController class]);
            mockDelegate = mockProtocol(@protocol(ContentProviderDelegate));
            sut.delegate = mockDelegate;
        });

        action(^{
            [sut updateSearchResultsForSearchController:mockSearchController];
        });

        it(@"should inform its delegate that it updated content", ^{
            [verify(mockDelegate) contentProviderDidUpdateContent:sut];
        });

        it(@"should have all the tests in place", ^{
            expect(NO).to.beTruthy();
        });
    });
});

SpecEnd
