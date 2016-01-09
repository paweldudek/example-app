/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "PendingRequestContainer.h"

@interface PendingRequestContainer ()
@property(nonatomic, strong) NSMutableData *internalResponseData;
@end

@implementation PendingRequestContainer

- (instancetype)initWithRequest:(id <NetworkLayerRequest>)request underlyingTask:(NSURLSessionDataTask *)underlyingTask completion:(NetworkLayerRequestCompletion)completion {
    self = [super init];
    if (self) {
        _request = request;
        _underlyingTask = underlyingTask;
        _completion = completion;

        self.internalResponseData = [NSMutableData data];
    }

    return self;
}

#pragma mark -

- (void)appendResponseData:(NSData *)data {
    [self.internalResponseData appendData:data];
}

- (NSData *)responseData {
    return [self.internalResponseData copy];
}

- (NSNumber *)identifier {
    return @(self.underlyingTask.taskIdentifier);
}

@end
