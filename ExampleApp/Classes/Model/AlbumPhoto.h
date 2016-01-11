/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AlbumPhoto : NSManagedObject

@property(nonatomic, strong) NSURL *thumbnailUrl;

@property(nonatomic, strong) NSNumber *identifier;

@end
