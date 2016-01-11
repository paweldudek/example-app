/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import <CoreData/CoreData.h>
#import "SearchUsersProvider.h"
#import "PersistenceController.h"
#import "User.h"
#import "NSManagedObject+Convenience.h"


@interface SearchUsersProvider ()
@property(nonatomic, strong) NSArray *users;
@end

@implementation SearchUsersProvider
@synthesize delegate;

- (instancetype)initWithPersistenceController:(PersistenceController *)persistenceController {
    self = [super init];
    if (self) {
        _persistenceController = persistenceController;
    }

    return self;
}

#pragma mark - Content Provide

- (NSString *)title {
    return NSLocalizedString(@"Search", nil);
}

- (void)updateContent {
    // noop
}

#pragma mark - Users Provider

- (NSUInteger)numberOfObjects {
    return self.users.count;
}

- (id)objectAtIndex:(NSInteger)index {
    return self.users[(NSUInteger) index];
}

#pragma mark - UISearchUpdater

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name beginsWith[CD] %@",
                                                              searchController.searchBar.text];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    self.users = [User allFromContext:self.persistenceController.mainThreadManagedObjectContext
                            predicate:predicate
                      sortDescriptors:sortDescriptors];

    [self.delegate contentProviderDidUpdateContent:self];
}

@end
