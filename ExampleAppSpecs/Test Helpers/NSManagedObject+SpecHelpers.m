/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "NSManagedObject+SpecHelpers.h"
#import "NSManagedObjectContext+SpecHelpers.h"


@implementation NSManagedObject (SpecHelpers)

+ (instancetype)specsEmptyObject {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self)
                                         inManagedObjectContext:[NSManagedObjectContext specsManagedObjectContext]];
}


@end
