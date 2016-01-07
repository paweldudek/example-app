/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class User;
@class UsersViewController;

@protocol UsersProvider <NSObject>

@end


@protocol UsersViewControllerDelegate <NSObject>

- (void)usersViewController:(UsersViewController *)viewController didSelectUser:(User *)user;

@end

@interface UsersViewController : UIViewController

@property(nonatomic, weak) id <UsersViewControllerDelegate> delegate;

@property(nonatomic, readonly) id <UsersProvider> usersProvider;

- (instancetype)initWithUsersProvider:(id <UsersProvider>)usersProvider;

@end
