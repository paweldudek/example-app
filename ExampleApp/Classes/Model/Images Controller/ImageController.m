/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "ImageController.h"
#import "FICImageCache.h"


@implementation ImageController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCache = [[FICImageCache alloc] init];
        self.imageCache.delegate = self;
        [self.imageCache setFormats:@[]];

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

    [self.session downloadTaskWithRequest:request
                        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                            UIImage *image = [UIImage imageWithContentsOfFile:location.relativePath];
                            completionBlock(image);
                        }];
}

@end
