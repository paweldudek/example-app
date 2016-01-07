/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "ContainerView.h"


@implementation ContainerView

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
