#import "Specs.h"

#import "AlbumPhotosPresentationController.h"
#import "AlbumPhoto.h"
#import "NSManagedObject+SpecHelpers.h"

SpecBegin(AlbumPhotosPresentationController)

describe(@"AlbumPhotosPresentationController", ^{

    __block AlbumPhotosPresentationController *sut;

    beforeEach(^{
        sut = [[AlbumPhotosPresentationController alloc] init];
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

        it(@"should return table view cell ni", ^{
            // We can't directly compare nibs, but we can check what's inside
            expect([tableViewCellNib instantiateWithOwner:nil
                                                  options:nil].firstObject).to.beKindOf([UITableViewCell class]);
        });
    });

    describe(@"configure cell", ^{

        IN_MEMORY_CORE_DATA

        __block UITableViewCell *tableViewCell;
        __block AlbumPhoto *albumPhoto;

        beforeEach(^{
            albumPhoto = [AlbumPhoto specsEmptyObject];
            albumPhoto.title = @"Fixture Title";

            tableViewCell = [[UINib nibWithNibName:@"AlbumPhotoTableViewCell" bundle:nil] instantiateWithOwner:nil
                                                                                                       options:nil].firstObject;
        });

        action(^{
            [sut configureTableViewCell:tableViewCell atIndexPath:nil withObject:albumPhoto];
        });

        it(@"should have title with user name", ^{
            expect(tableViewCell.textLabel.text).to.equal(@"Fixture Title");
        });
    });
});

SpecEnd
