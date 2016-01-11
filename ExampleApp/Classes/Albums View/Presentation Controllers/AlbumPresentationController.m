/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AlbumPresentationController.h"
#import "Album.h"


@implementation AlbumPresentationController
@synthesize tableView = _tableView;

- (UINib *)tableViewCellNib {
    return [UINib nibWithNibName:@"AlbumTableViewCell" bundle:nil];
}

- (CGFloat)estimatedCellHeight {
    return 44;
}

- (void)configureTableViewCell:(__kindof UITableViewCell *)tableViewCell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    NSAssert([object isKindOfClass:[Album class]], @"%@ works only with album objects.", [self class]);
    Album *album = object;

    tableViewCell.textLabel.text = album.title;
}

- (void)selectObject:(id)object {
    [self.delegate albumPresentationController:self didSelectAlbum:object];
}

@end
