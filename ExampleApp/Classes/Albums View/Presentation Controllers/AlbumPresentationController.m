/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AlbumPresentationController.h"
#import "Album.h"


@implementation AlbumPresentationController

- (UINib *)tableViewCellNib {
    return [UINib nibWithNibName:@"AlbumTableViewCell" bundle:nil];
}

- (CGFloat)estimatedCellHeight {
    return 44;
}

- (void)configureTableViewCell:(UITableViewCell *)tableViewCell withObject:(Album *)album {
    tableViewCell.textLabel.text = album.title;
}

- (void)selectObject:(id)object {
    [self.delegate albumPresentationController:self didSelectAlbum:object];
}

@end
