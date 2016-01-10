/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentProvider.h"

@class User;
@class UsersViewController;

@protocol UsersProvider <ContentProvider>

- (NSUInteger)numberOfUsers;

- (User *)userAtIndex:(NSInteger)index;

@end


@protocol UsersViewControllerDelegate <NSObject>

- (void)usersViewController:(UsersViewController *)viewController didSelectUser:(User *)user;

@end

@interface UsersViewController : UIViewController <ContentProviderDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) id <UsersViewControllerDelegate> delegate;

@property(nonatomic, readonly) id <UsersProvider> usersProvider;

/*
 * Will be nil until view is loaded.
 */
@property(nonatomic, readonly) UITableView *tableView;

- (instancetype)initWithUsersProvider:(id <UsersProvider>)usersProvider;

@end
