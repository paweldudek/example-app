/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import <CoreData/CoreData.h>
#import "UpdateUsersOperation.h"
#import "UsersUpdater.h"
#import "NetworkLayer.h"
#import "NetworkLayer+ExampleApp.h"
#import "UsersNetworkLayerRequest.h"
#import "PersistenceController.h"


@implementation UpdateUsersOperation

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController {
    self = [super init];
    if (self) {
        _persistenceController = persistenceController;

        self.usersUpdater = [[UsersUpdater alloc] init];
        self.networkLayer = [NetworkLayer exampleAppNetworkLayer];
    }

    return self;
}

- (void)start {
    [super start];

    [self.networkLayer makeRequest:[UsersNetworkLayerRequest new]
                        completion:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if (error == nil) {
                                [self parseResponse:data];
                            }
                            else {
                                self.updateCompletion(error);
                            }
                        }];
}

#pragma mark -

- (void)parseResponse:(NSData *)data {
    NSArray *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    managedObjectContext.parentContext = self.persistenceController.mainThreadManagedObjectContext;

    [managedObjectContext performBlockAndWait:^{
        [self.usersUpdater updateUsersWithResponse:parsedData managedObjectContext:managedObjectContext];
    }];
}

@end
