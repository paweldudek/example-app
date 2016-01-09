/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "ContainerView.h"


@implementation ContainerView

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];

    self.containedView.frame = self.bounds;
    self.overlayView.frame = self.bounds;
}

#pragma mark - Overridden Setters

- (void)setContainedView:(UIView *)containedView {
    [_containedView removeFromSuperview];
    _containedView = containedView;
    [self addSubview:_containedView];
}

- (void)setOverlayView:(UIView *)overlayView {
    [_overlayView removeFromSuperview];
    _overlayView = overlayView;
    [self addSubview:_overlayView];
}

@end
