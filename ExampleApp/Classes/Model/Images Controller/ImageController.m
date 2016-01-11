/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "ImageController.h"
#import "FICImageCache.h"
#import "FICImageFormat+ExampleApp.h"


@implementation ImageController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCache = [[FICImageCache alloc] init];
        self.imageCache.delegate = self;
        [self.imageCache setFormats:@[[FICImageFormat tableViewCellImageFormat]]];

        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }

    return self;
}

#pragma mark - Retrieving Images

- (void)retrieveImageForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageCacheCompletionBlock)completionBlock {
    [self.imageCache asynchronouslyRetrieveImageForEntity:entity
                                           withFormatName:formatName
                                          completionBlock:completionBlock];
}

#pragma mark - Image Cache Delegate

- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {
    NSURLRequest *request = [NSURLRequest requestWithURL:[entity sourceImageURLWithFormatName:formatName]];

    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request
                                                                 completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                                     // Don't use image with contents with file as it defers data read - this file will be remove after we exit this block
                                                                     UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:location.relativePath]];
                                                                     completionBlock(image);
                                                                 }];
    [downloadTask resume];
}

@end
