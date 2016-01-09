/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import "NetworkLayer.h"

@protocol NetworkLayerRequest;


@interface PendingRequestContainer : NSObject

@property(nonatomic, readonly) NetworkLayerRequestCompletion completion;
@property(nonatomic, readonly) id <NetworkLayerRequest> request;
@property(nonatomic, readonly) NSURLSessionDataTask *underlyingTask;

@property(nonatomic, readonly) NSData *responseData;

@property(nonatomic, readonly) NSNumber *identifier;

- (instancetype)initWithRequest:(id <NetworkLayerRequest>)request underlyingTask:(NSURLSessionDataTask *)underlyingTask completion:(NetworkLayerRequestCompletion)completion;

- (void)appendResponseData:(NSData *)data;

@end
