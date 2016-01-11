#import "Specs.h"

#import "AlbumPresentationController.h"
#import "Album.h"
#import "NSManagedObject+SpecHelpers.h"

SpecBegin(AlbumPresentationController)

describe(@"AlbumPresentationController", ^{

    __block AlbumPresentationController *sut;

    beforeEach(^{
        sut = [[AlbumPresentationController alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have appropriate estimated height", ^{
        expect(sut.estimatedCellHeight).to.equal(44);
    });

    describe(@"table view cell nib", ^{

        __block UINib *tableViewCellNib;

        action(^{
            tableViewCellNib = [sut tableViewCellNib];
        });

        it(@"should return users table view cell ni", ^{
            // We can't directly compare nibs, but we can check what's inside
            expect([tableViewCellNib instantiateWithOwner:nil options:nil].firstObject).to.beKindOf([UITableViewCell class]);
        });
    });

    describe(@"configure cell", ^{

        IN_MEMORY_CORE_DATA

        __block UITableViewCell *tableViewCell;
        __block Album *album;

        beforeEach(^{
            album = [Album specsEmptyObject];
            album.title = @"Fixture Album Title";

            tableViewCell = [[UINib nibWithNibName:@"AlbumTableViewCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
        });

        action(^{
            [sut configureTableViewCell:tableViewCell withObject:album];
        });

        it(@"should have text label with album title", ^{
            expect(tableViewCell.textLabel.text).to.equal(@"Fixture Album Title");
        });
    });

    describe(@"select object", ^{

        IN_MEMORY_CORE_DATA

        __block Album *album;
        __block id mockDelegate;

        beforeEach(^{
            album = [Album specsEmptyObject];

            mockDelegate = mockProtocol(@protocol(AlbumPresentationControllerDelegate));
            sut.delegate = mockDelegate;
        });

        action(^{
            [sut selectObject:album];
        });

        it(@"should inform its delegate that user was selected", ^{
            [verify(mockDelegate) albumPresentationController:sut didSelectAlbum:album];
        });
    });
});

SpecEnd
