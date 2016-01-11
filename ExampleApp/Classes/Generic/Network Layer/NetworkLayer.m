/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "NetworkLayer.h"
#import "PendingRequestContainer.h"


@interface NetworkLayer ()
@property(nonatomic, strong) NSMutableDictionary *pendingRequests;
@end

@implementation NetworkLayer

- (instancetype)initWithBaseURL:(NSURL *)baseURL {
    self = [super init];
    if (self) {
        _baseURL = baseURL;

        self.pendingRequests = [NSMutableDictionary new];
        
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                     delegate:self
                                                delegateQueue:nil];
    }

    return self;
}

- (id)makeRequest:(id <NetworkLayerRequest>)request completion:(NetworkLayerRequestCompletion)completion {
    NSURL *fullURL =  [self.baseURL URLByAppendingPathComponent:request.endpoint];
    NSLog(@"Sending request %@", fullURL);

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:fullURL];
    urlRequest.HTTPMethod = @"GET";
    urlRequest.cachePolicy = NSURLRequestUseProtocolCachePolicy;

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:urlRequest];

    PendingRequestContainer *container = [[PendingRequestContainer alloc] initWithRequest:request
                                                                           underlyingTask:task
                                                                               completion:completion];
    NSNumber *identifier = container.identifier;
    self.pendingRequests[identifier] = container;

    [task resume];

    return identifier;
}

- (void)cancelRequestWithIdentifier:(id)identifier {
    PendingRequestContainer *container = self.pendingRequests[identifier];
    [self.pendingRequests removeObjectForKey:identifier];
    [container.underlyingTask cancel];
}

#pragma mark - NSURLSession Delegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    PendingRequestContainer *requestContainer = self.pendingRequests[@(task.taskIdentifier)];
    [self.pendingRequests removeObjectForKey:@(task.taskIdentifier)];

    NSLog(@"Received response for URL: %@", task.originalRequest.URL);

    id response = requestContainer.responseData;

    if (requestContainer.completion) {
        requestContainer.completion(response, task.response, error);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    PendingRequestContainer *requestContainer = self.pendingRequests[@(dataTask.taskIdentifier)];
    [requestContainer appendResponseData:data];
}

@end
