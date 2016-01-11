/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "FICImageFormat+ExampleApp.h"

NSString *EXATableViewCellImageFormatName = @"EXATableViewCellImageFormatName";

@implementation FICImageFormat (ExampleApp)

+ (instancetype)tableViewCellImageFormat {
    FICImageFormat *imageFormat = [[self alloc] init];
    imageFormat.name = EXATableViewCellImageFormatName;
    imageFormat.style = FICImageFormatStyle16BitBGR;
    imageFormat.imageSize = CGSizeMake(40, 40);
    imageFormat.maximumCount = 250;
    imageFormat.devices = FICImageFormatDevicePhone;
    imageFormat.protectionMode = FICImageFormatProtectionModeNone;
    return imageFormat;
}

@end
