/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UsersViewController.h"
#import "AlbumsViewController.h"

@protocol ViewControllerPresenter;
@class ApplicationController;


@interface RootFlowViewController : UIViewController <UsersViewControllerDelegate, AlbumsViewControllerDelegate>

@property(nonatomic, strong) id <ViewControllerPresenter> viewControllerPresenter;

@property(nonatomic, readonly) ApplicationController *applicationController;

/*
 * Will be loaded with view.
 */
@property(nonatomic, readonly) UISearchController *userSearchController;

- (instancetype)initWithApplicationController:(ApplicationController *)applicationController;

@end
