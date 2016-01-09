/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class PersistenceController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic, strong) UIWindow *window;

@property(nonatomic, strong) PersistenceController *persistenceController;

@end

