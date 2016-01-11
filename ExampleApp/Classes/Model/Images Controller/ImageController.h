/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <FastImageCache/FICImageCache.h>

@class FICImageCache;


@interface ImageController : NSObject <FICImageCacheDelegate>

@property(nonatomic, strong) FICImageCache *imageCache;

@property(nonatomic, strong) NSURLSession *session;

- (void)retrieveImageForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageCacheCompletionBlock)completionBlock;

@end
