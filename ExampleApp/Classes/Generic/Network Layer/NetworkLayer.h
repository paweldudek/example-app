/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>

typedef void (^NetworkLayerRequestCompletion)(NSData *, NSURLResponse *, NSError *);

@protocol NetworkLayerRequest <NSObject>

@property(nonatomic, readonly) NSString *endpoint;

@end

/*
 * This class could probably use a bit of an upgrade, for instance we lack proper NSURLResponse non-ok codes handling (4xx, 5xx)
 * Plus we could add data transformers here to prepare JSON objects here rather than pass this responsibility to consumers.
 * However for the time being this should suffice.
 */
@interface NetworkLayer : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property(nonatomic, strong) NSURLSession *session;

@property(nonatomic, readonly) NSURL *baseURL;

- (instancetype)initWithBaseURL:(NSURL *)baseURL;

- (id)makeRequest:(id <NetworkLayerRequest>)request completion:(NetworkLayerRequestCompletion)completion;

- (void)cancelRequestWithIdentifier:(id)identifier;

@end
