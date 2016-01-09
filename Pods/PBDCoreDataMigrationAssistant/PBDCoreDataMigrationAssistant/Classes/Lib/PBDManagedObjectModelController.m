/*
 * Copyright (c) 2015 Dudek. All rights reserved.
 */
#import "PBDManagedObjectModelController.h"
#import "NSBundle+PBDBundleVersionString.h"


@implementation PBDManagedObjectModelController

- (instancetype)initWithManagedObjectModelURL:(NSURL *)managedObjectModelURL {
    self = [super init];
    if (self) {
        _managedObjectModelURL = managedObjectModelURL;
    }

    return self;
}

#pragma mark -

- (void)archiveManagedObjectModel:(NSManagedObjectModel *)model {
    NSString *versionString = [[NSBundle mainBundle] pbd_bundleVersionString];
    if (![model.versionIdentifiers containsObject:versionString]) {
        model.versionIdentifiers = [model.versionIdentifiers setByAddingObject:versionString];
    }

    [NSKeyedArchiver archiveRootObject:model toFile:[[self managedObjectModelURL] relativePath]];
}

- (NSManagedObjectModel *)unarchivedManagedObjectModel {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.managedObjectModelURL];
}

@end
