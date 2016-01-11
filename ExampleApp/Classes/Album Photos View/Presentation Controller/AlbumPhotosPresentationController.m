/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AlbumPhotosPresentationController.h"
#import "AlbumPhoto.h"


@implementation AlbumPhotosPresentationController

- (UINib *)tableViewCellNib {
    return [UINib nibWithNibName:@"AlbumPhotoTableViewCell" bundle:nil];
}

- (CGFloat)estimatedCellHeight {
    return 44;
}

- (void)configureTableViewCell:(__kindof UITableViewCell *)tableViewCell withObject:(AlbumPhoto *)albumPhoto {
    tableViewCell.textLabel.text = albumPhoto.title;
}

- (void)selectObject:(id)object {
    // noop
}

@end
