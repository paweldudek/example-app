/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "LoadingView.h"
#import <PureLayout/PureLayout.h>

@interface LoadingView ()
@property(nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic, readonly) UIView *backgroundView;
@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.4f];
        _backgroundView.layer.cornerRadius = 6.0f;
        [self addSubview:_backgroundView];

        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicatorView startAnimating];
        [_backgroundView addSubview:_activityIndicatorView];

        self.userInteractionEnabled = NO;

        [NSLayoutConstraint autoCreateAndInstallConstraints:^{
            [_backgroundView autoCenterInSuperview];
            [_activityIndicatorView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }];
    }

    return self;
}

@end
