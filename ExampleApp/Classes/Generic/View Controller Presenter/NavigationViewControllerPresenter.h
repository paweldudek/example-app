/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "ViewControllerPresenter.h"


@interface NavigationViewControllerPresenter : NSObject <ViewControllerPresenter>

@property(nonatomic, readonly) UINavigationController *navigationController;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end
