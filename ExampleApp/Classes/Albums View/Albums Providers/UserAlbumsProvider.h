/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "ContentProvider.h"
#import "AlbumsViewController.h"

@class User;


@interface UserAlbumsProvider : NSObject <AlbumsProvider>

@property(nonatomic, readonly) User *user;

- (instancetype)initWithUser:(User *)user;


@end
