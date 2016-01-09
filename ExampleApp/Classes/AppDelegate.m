/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/

#import "AppDelegate.h"
#import "RootFlowViewController.h"
#import "PersistenceController.h"
#import "ApplicationController.h"
#import "NSFileManager+ExampleApp.h"

@implementation AppDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *coreDataURL = [[[NSFileManager defaultManager] applicationSupportDirectoryURL] URLByAppendingPathComponent:@"CoreData"];
        self.persistenceController = [[PersistenceController alloc] initWithCoreDataStackFolderURL:coreDataURL];

        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }

    return self;
}

#pragma mark - UIApplication Delegate

- (BOOL)application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions {
    [self.persistenceController setupCoreDataStack];

    ApplicationController *applicationController = [[ApplicationController alloc] initWithPersistenceController:self.persistenceController];
    self.window.rootViewController = [[RootFlowViewController alloc] initWithApplicationController:applicationController];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
