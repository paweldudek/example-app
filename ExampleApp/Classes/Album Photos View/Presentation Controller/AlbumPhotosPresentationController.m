/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AlbumPhotosPresentationController.h"
#import "AlbumPhoto.h"
#import "AlbumPhoto+ImageCache.h"
#import "ImageController.h"
#import "FICImageFormat+ExampleApp.h"


@implementation AlbumPhotosPresentationController
@synthesize tableView = _tableView;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageController = [[ImageController alloc] init];
    }

    return self;
}

#pragma mark -

- (UINib *)tableViewCellNib {
    return [UINib nibWithNibName:@"AlbumPhotoTableViewCell" bundle:nil];
}

- (CGFloat)estimatedCellHeight {
    return 44;
}

- (void)configureTableViewCell:(__kindof UITableViewCell *)tableViewCell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    NSAssert([object isKindOfClass:[AlbumPhoto class]], @"%@ works only with album photos objects.", [self class]);
    AlbumPhoto *albumPhoto = object;

    tableViewCell.textLabel.text = albumPhoto.title;

    [self.imageController retrieveImageForEntity:albumPhoto withFormatName:EXATableViewCellImageFormatName
                                 completionBlock:^(id <FICEntity> entity, NSString *formatName, UIImage *image) {
                                     UITableViewCell *viewCell = [self.tableView cellForRowAtIndexPath:indexPath];
                                     viewCell.imageView.image = image;
                                 }];
}

- (void)selectObject:(id)object {
    // noop
}

@end
