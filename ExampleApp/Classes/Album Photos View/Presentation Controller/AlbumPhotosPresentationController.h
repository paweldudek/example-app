/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "TableContentPresentationController.h"

@class ImageController;

@interface AlbumPhotosPresentationController : NSObject <TableContentPresentationController>

@property(nonatomic, strong) ImageController *imageController;
@end
