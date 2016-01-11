/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import <CoreData/CoreData.h>
#import "GenericUpdateContentOperation.h"
#import "NetworkLayer.h"
#import "NetworkLayer+ExampleApp.h"
#import "PersistenceController.h"


@interface GenericUpdateContentOperation ()
@property(nonatomic, strong) id requestIdentifier;
@end

@implementation GenericUpdateContentOperation

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController {
    self = [super init];
    if (self) {
        _persistenceController = persistenceController;

        self.networkLayer = [NetworkLayer exampleAppNetworkLayer];

        self.completionQueue = [NSOperationQueue mainQueue];
    }

    return self;
}

#pragma mark - NSOperation

- (void)start {
    [super start];

    self.requestIdentifier = [self.networkLayer makeRequest:self.request
                                                 completion:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     if (error == nil) {
                                                         [self parseResponse:data];
                                                     }
                                                     else {
                                                         [self finishWithError:error];
                                                     }
                                                 }];
}

- (void)cancel {
    [super cancel];

    [self.networkLayer cancelRequestWithIdentifier:self.requestIdentifier];
}

#pragma mark -

- (void)parseResponse:(NSData *)data {
    NSArray *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    managedObjectContext.parentContext = self.persistenceController.mainThreadManagedObjectContext;

    [managedObjectContext performBlockAndWait:^{
        [self.contentUpdater updateContentWithArray:parsedData managedObjectContext:managedObjectContext];
    }];

    [self.persistenceController saveChildContext:managedObjectContext
                                      completion:^(BOOL succeeded, NSError *error) {
                                          [self finishWithError:error];
                                      }];
}

#pragma mark - Finishing Helpers

- (void)finishWithError:(NSError *)error {
    [self.completionQueue addOperationWithBlock:^{
        if (self.updateCompletion) {
            self.updateCompletion(error);
            [self finishExecution];
        }
    }];
}

@end
