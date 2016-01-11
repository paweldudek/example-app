/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>

@protocol ContentProvider;

@protocol ContentProviderDelegate <NSObject>

- (void)contentProviderWillBeginUpdatingData:(id <ContentProvider>)contentProvider;

- (void)contentProviderDidFinishUpdatingData:(id <ContentProvider>)contentProvider;

- (void)contentProviderDidUpdateContent:(id <ContentProvider>)contentProvider;

@end

@protocol ContentProvider <NSObject>

@property(nonatomic, weak) id <ContentProviderDelegate> delegate;

@property(nonatomic, readonly) NSString *title;

#pragma mark - Reloading Content

- (void)updateContent;

#pragma mark - Data Source

- (NSUInteger)numberOfObjects;

- (id)objectAtIndex:(NSInteger)index;

@end
