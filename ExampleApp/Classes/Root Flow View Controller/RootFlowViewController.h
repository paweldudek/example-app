/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UsersViewController.h"

@protocol ViewControllerPresenter;


@interface RootFlowViewController : UIViewController <UsersViewControllerDelegate>

@property(nonatomic, strong) id <ViewControllerPresenter> viewControllerPresenter;

@end
