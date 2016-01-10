/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentProvider.h"

@class Album;
@class AlbumsViewController;

@protocol AlbumsViewControllerDelegate <NSObject>

- (void)albumsViewController:(AlbumsViewController *)viewController didSelectAlbum:(Album *)album;

@end

@protocol AlbumsProvider <ContentProvider>

@end

@interface AlbumsViewController : UIViewController

@property(nonatomic, readonly) id <AlbumsProvider> albumsProvider;

@property(nonatomic, weak) id <AlbumsViewControllerDelegate> delegate;

- (instancetype)initWithAlbumsProvider:(id <AlbumsProvider>)albumsProvider;


@end
