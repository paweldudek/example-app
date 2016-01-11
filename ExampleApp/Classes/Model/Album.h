/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Album : NSManagedObject

@property(nonatomic, strong) NSString *title;

@property(nonatomic, strong) NSNumber *userIdentifier;

@property(nonatomic, strong) NSNumber *identifier;

@end
