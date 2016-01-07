/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) NSString *email;

@property(nonatomic, strong) NSString *identifier;

@end
