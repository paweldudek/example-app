/*
 * Copyright (c) 2015 ManyGuide B.V. All rights reserved.
 */
#import <CoreData/CoreData.h>
#import "PBDCoreDataMigrationAssistant.h"

@implementation PBDCoreDataMigrationAssistant

- (instancetype)initWithStoreURL:(NSURL *)storeURL sourceModel:(NSManagedObjectModel *)sourceModel destinationModel:(NSManagedObjectModel *)destinationModel {
    self = [super init];
    if (self) {
        _sourceModel = sourceModel;
        _destinationModel = destinationModel;
        _storeURL = storeURL;

        self.fileManager = [NSFileManager defaultManager];
    }

    return self;
}

- (BOOL)migrateStoreWithError:(NSError **)error {
    NSError *inferringError = nil;
    NSMappingModel *mappingModel = [NSMappingModel inferredMappingModelForSourceModel:self.sourceModel
                                                                     destinationModel:self.destinationModel
                                                                                error:&inferringError];
    if (inferringError) {
        [[self delegate] migrationAssistant:self didFailToInferMappingModelWithError:inferringError];
        mappingModel = [[self delegate] mappingModelForMigrationAssistant:self];
    }

    NSAssert(mappingModel, @"No mapping model for migration assistant was provided.");

    NSString *temporaryFilePath = [[self.storeURL relativePath] stringByAppendingString:@"-temporary"];
    NSURL *temporaryFileURL = [NSURL fileURLWithPath:temporaryFilePath];

    [self.fileManager moveItemAtURL:self.storeURL toURL:temporaryFileURL error:nil];

    NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:self.sourceModel
                                                                          destinationModel:self.destinationModel];

    NSError *migrationError = nil;
    BOOL migrationSuccessful = [migrationManager migrateStoreFromURL:temporaryFileURL
                                                                type:NSSQLiteStoreType
                                                             options:nil
                                                    withMappingModel:mappingModel
                                                    toDestinationURL:self.storeURL
                                                     destinationType:NSSQLiteStoreType
                                                  destinationOptions:nil
                                                               error:&migrationError];

    [self.fileManager removeItemAtURL:temporaryFileURL error:nil];

    if (error) {
        *error = migrationError;
    }

    return migrationSuccessful;
}

@end
