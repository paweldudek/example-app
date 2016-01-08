/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class PersistenceController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic, strong) PersistenceController *persistenceController;

- (NSURL *)applicationDocumentsDirectory;

@end

