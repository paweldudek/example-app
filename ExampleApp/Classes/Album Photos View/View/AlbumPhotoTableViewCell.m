/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AlbumPhotoTableViewCell.h"


@implementation AlbumPhotoTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];

    self.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
}

@end
