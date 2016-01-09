/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>


@interface Company : NSObject <NSCoding>

@property(nonatomic, readonly) NSString *name;

@property(nonatomic, readonly) NSString *catchphrase;

- (instancetype)initWithName:(NSString *)name catchphrase:(NSString *)catchphrase;

- (instancetype)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

@end
