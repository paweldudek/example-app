/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ContainerView : UIView

@property(nonatomic, strong) UIView *containedView;

@property(nonatomic, strong) UIView *overlayView;

@end
