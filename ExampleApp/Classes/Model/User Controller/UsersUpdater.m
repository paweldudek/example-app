/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import <CoreData/CoreData.h>
#import "UsersUpdater.h"
#import "User.h"
#import "NSManagedObject+Convenience.h"
#import "KZPropertyMapper.h"
#import "Company.h"


@implementation UsersUpdater

- (void)updateContentWithArray:(NSArray *)contentArray managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSMutableArray <User *> *deleteCandidates = [[User allFromContext:managedObjectContext] mutableCopy];

    for (NSDictionary *userDictionary in contentArray) {
        User *user = [User findFirstByIdentifier:userDictionary[@"id"]
                                     fromContext:managedObjectContext];
        if (user == nil) {
            user = [User newFromContext:managedObjectContext];
        }

        [KZPropertyMapper mapValuesFrom:userDictionary
                             toInstance:user
                           usingMapping:@{
                                   @"name" : KZPropertyT(user, name),
                                   @"id" : KZPropertyT(user, identifier),
                                   @"email" : KZPropertyT(user, email)
                           }];

        NSDictionary *companyDictionary = userDictionary[@"company"];
        Company *company = [[Company alloc] initWithName:companyDictionary[@"name"]
                                             catchphrase:companyDictionary[@"catchPhrase"]];
        user.company = company;

        [deleteCandidates removeObject:user];
    }

    for (User *deleteCandidate in deleteCandidates) {
        [managedObjectContext deleteObject:deleteCandidate];
    }
}

@end
