/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "TableContentViewController.h"

@class AlbumPresentationController;
@class Album;

@protocol AlbumPresentationControllerDelegate <NSObject>

- (void)albumPresentationController:(AlbumPresentationController *)controller didSelectAlbum:(Album *)album;

@end

@interface AlbumPresentationController : NSObject <TableContentPresentationController>

@property(nonatomic, weak) id <AlbumPresentationControllerDelegate> delegate;

@end
