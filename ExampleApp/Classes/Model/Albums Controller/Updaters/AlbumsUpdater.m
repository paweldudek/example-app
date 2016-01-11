/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import <CoreData/CoreData.h>
#import <KZPropertyMapper/KZPropertyMapper.h>
#import "AlbumsUpdater.h"
#import "Album.h"
#import "NSManagedObject+Convenience.h"


@implementation AlbumsUpdater

- (void)updateContentWithArray:(NSArray *)contentArray managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSMutableArray <Album *> *deleteCandidates = [[Album allFromContext:managedObjectContext] mutableCopy];

    for (NSDictionary *userDictionary in contentArray) {
        Album *album = [Album findFirstByIdentifier:userDictionary[@"id"]
                                     fromContext:managedObjectContext];
        if (album == nil) {
            album = [Album newFromContext:managedObjectContext];
        }

        [KZPropertyMapper mapValuesFrom:userDictionary
                             toInstance:album
                           usingMapping:@{
                                   @"title" : KZPropertyT(album, title),
                                   @"id" : KZPropertyT(album, identifier),
                                   @"userId" : KZPropertyT(album, userIdentifier)
                           }];

        [deleteCandidates removeObject:album];
    }

    for (Album *deleteCandidate in deleteCandidates) {
        [managedObjectContext deleteObject:deleteCandidate];
    }
}

@end
