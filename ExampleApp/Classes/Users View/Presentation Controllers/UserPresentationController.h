/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "TableContentPresentationController.h"

@class UserPresentationController;
@class User;

@protocol UserPresentationControllerDelegate <NSObject>

-(void)userPresentationController:(UserPresentationController *)presentationController didSelectUser:(User *)user;

@end

@interface UserPresentationController : NSObject <TableContentPresentationController>

@property(nonatomic, weak) id <UserPresentationControllerDelegate> delegate;

@end
