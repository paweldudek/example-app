/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import <KZPropertyMapper/KZPropertyMapper.h>
#import "AlbumsPhotosUpdater.h"
#import "AlbumPhoto.h"
#import "NSManagedObject+Convenience.h"


@implementation AlbumsPhotosUpdater

- (void)updateContentWithArray:(NSArray *)contentArray managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([AlbumPhoto class])];
    fetchRequest.returnsObjectsAsFaults = NO;

    NSMutableArray <AlbumPhoto *> *deleteCandidates = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

    for (NSDictionary *albumPhotoDictionary in contentArray) {
        NSNumber *albumIdentifier = albumPhotoDictionary[@"id"];
        NSPredicate *albumPredicate = [NSPredicate predicateWithFormat:@"identifier == %@", albumIdentifier];
        AlbumPhoto *albumPhoto = [deleteCandidates filteredArrayUsingPredicate:albumPredicate].firstObject;

        if (albumPhoto == nil) {
            albumPhoto = [AlbumPhoto newFromContext:managedObjectContext];
        }

        [KZPropertyMapper mapValuesFrom:albumPhotoDictionary
                             toInstance:albumPhoto
                           usingMapping:@{
                                   @"title" : KZPropertyT(albumPhoto, title),
                                   @"id" : KZPropertyT(albumPhoto, identifier),
                                   @"thumbnailUrl" : KZBoxT(albumPhoto, URL, thumbnailUrl),
                                   @"albumId" : KZPropertyT(albumPhoto, albumIdentifier)
                           }];

        [deleteCandidates removeObject:albumPhoto];
    }

    for (AlbumPhoto *deleteCandidate in deleteCandidates) {
        [managedObjectContext deleteObject:deleteCandidate];
    }
}

@end
