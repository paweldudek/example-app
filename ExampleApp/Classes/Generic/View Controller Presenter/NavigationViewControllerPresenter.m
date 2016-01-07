/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "NavigationViewControllerPresenter.h"


@implementation NavigationViewControllerPresenter

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }

    return self;
}

#pragma mark -

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController.transitionCoordinator animateAlongsideTransition:nil
                                                          completion:^(id <UIViewControllerTransitionCoordinatorContext> context) {
                                                              if (completion) {
                                                                  completion();
                                                              }
                                                          }];
}

@end
