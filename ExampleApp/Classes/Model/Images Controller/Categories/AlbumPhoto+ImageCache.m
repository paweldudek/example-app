/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "AlbumPhoto+ImageCache.h"
#import "FICUtilities.h"


@implementation AlbumPhoto (ImageCache)

- (NSString *)UUID {
    CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString([self.identifier description]);
    return FICStringWithUUIDBytes(UUIDBytes);
}

- (NSString *)sourceImageUUID {
    NSString *sourceUUID = nil;
    if (self.thumbnailUrl) {
        CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString(self.thumbnailUrl.absoluteString);
        sourceUUID = FICStringWithUUIDBytes(UUIDBytes);
    }
    return sourceUUID;
}

- (NSURL *)sourceImageURLWithFormatName:(NSString *)formatName {
    return self.thumbnailUrl;
}

- (FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName {
    return ^(CGContextRef context, CGSize contextSize) {
        CGRect contextBounds = CGRectZero;
        contextBounds.size = contextSize;
        CGContextClearRect(context, contextBounds);

        UIGraphicsPushContext(context);
        [image drawInRect:contextBounds];
        UIGraphicsPopContext();
    };
}

@end
