/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Album;
@class AlbumsViewController;

@protocol AlbumsViewControllerDelegate <NSObject>

- (void)albumsViewController:(AlbumsViewController *)viewController didSelectAlbum:(Album *)album;

@end

@interface AlbumsViewController : UIViewController

@property(nonatomic, weak) id <AlbumsViewControllerDelegate> delegate;

@end
