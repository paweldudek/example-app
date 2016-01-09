/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "Company.h"


@implementation Company

- (instancetype)initWithName:(NSString *)name catchphrase:(NSString *)catchphrase {
    self = [super init];
    if (self) {
        _name = name;
        _catchphrase = catchphrase;
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"_name"];
        _catchphrase = [coder decodeObjectForKey:@"_catchphrase"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"_name"];
    [coder encodeObject:self.catchphrase forKey:@"_catchphrase"];
}

@end
