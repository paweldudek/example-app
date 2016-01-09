#import "Specs.h"

#import "NetworkLayer.h"

SpecBegin(NetworkLayer)

describe(@"NetworkLayer", ^{

    __block NetworkLayer *sut;

    beforeEach(^{
        sut = [[NetworkLayer alloc] initWithBaseURL:[NSURL URLWithString:@"http://fixture.com"]];
    });

    afterEach(^{
        sut = nil;
    });

    describe(@"session", ^{

        __block NSURLSession *urlSession;

        action(^{
            urlSession = [sut session];
        });

        it(@"should be an NSURL session", ^{
            expect(urlSession).to.beKindOf([NSURLSession class]);
        });

        it(@"should have a delegate", ^{
            expect(urlSession.delegate).to.equal(sut);
        });
    });

    describe(@"make request", ^{

        __block id identifier;

        __block id mockRequest;
        __block id mockSession;
        __block id mockTask;
        __block id mockURLResponse;

        __block NetworkLayerRequestCompletion completion;

        __block id <NSURLSessionDelegate, NSURLSessionDataDelegate> delegate;

        beforeEach(^{
            mockRequest = mockProtocol(@protocol(NetworkLayerRequest));
            mockTask = mock([NSURLSessionTask class]);
            mockSession = mock([NSURLSession class]);
            mockURLResponse = mock([NSURLResponse class]);

            delegate = (id <NSURLSessionDelegate, NSURLSessionDataDelegate>) sut.session.delegate;

            sut.session = mockSession;

            [given([mockSession dataTaskWithRequest:anything()]) willReturn:mockTask];
            [given([mockTask response]) willReturn:mockURLResponse];
            [given([mockRequest endpoint]) willReturn:@"fixture/endpoint"];

            completion = nil;
        });

        action(^{
            identifier = [sut makeRequest:mockRequest completion:completion];
        });

        it(@"should tell the returned task to resume", ^{
            [verify(mockTask) resume];
        });

        describe(@"last request", ^{

            __block NSURLRequest *request;

            action(^{
                HCArgumentCaptor *captor = [HCArgumentCaptor new];
                [verify(mockSession) dataTaskWithRequest:(id) captor];
                request = [captor value];
            });

            it(@"should have an appropriate URL", ^{
                NSURLComponents *components = [[NSURLComponents alloc] initWithURL:request.URL
                                                           resolvingAgainstBaseURL:NO];
                components.queryItems = nil;
                expect([components URL]).to.equal([NSURL URLWithString:@"http://fixture.com/fixture/endpoint"]);
            });

            it(@"should be a GET request", ^{
                expect(request.HTTPMethod).to.equal(@"GET");
            });

            it(@"should have cache policy", ^{
                expect(request.cachePolicy).to.equal(NSURLRequestUseProtocolCachePolicy);
            });
        });

        describe(@"when the request is successful", ^{

            __block NSData *data;

            beforeEach(^{
                NSDictionary *responseDictionary = @{@"Fixture Response Value 1" : @"Fixture Response Key 1",
                        @"Fixture Response Value 2" : @"Fixture Response Key 2"};

                data = [NSJSONSerialization dataWithJSONObject:responseDictionary options:0 error:nil];
            });

            describe(@"when first chunk of data arrives", ^{

                __block BOOL completionCalled;

                beforeEach(^{
                    completion = ^(id o, NSURLResponse *response, NSError *error) {
                        completionCalled = YES;
                    };
                });

                action(^{
                    NSData *subdata = [data subdataWithRange:NSMakeRange(0, 42)];
                    [delegate URLSession:mockSession dataTask:mockTask didReceiveData:subdata];
                });

                it(@"should not call the completion block (yet)", ^{
                    expect(completionCalled).to.beFalsy();
                });

                describe(@"when the second chunk of data arrives and the whole request completes", ^{

                    __block NSError *capturedError;
                    __block id capturedResponseObject;
                    __block NSURLResponse *capturedURLResponse;
                    __block NSError *fixtureError;

                    beforeEach(^{
                        completion = ^(id o, NSURLResponse *response, NSError *error) {
                            capturedError = error;
                            capturedResponseObject = o;
                            capturedURLResponse = response;
                        };
                    });

                    action(^{
                        NSData *subdata = [data subdataWithRange:NSMakeRange(42, [data length] - 42)];
                        [delegate URLSession:mockSession dataTask:mockTask didReceiveData:subdata];

                        [delegate URLSession:mockSession task:mockTask didCompleteWithError:fixtureError];
                    });

                    it(@"should have the URL response", ^{
                        expect(capturedURLResponse).to.equal(mockURLResponse);
                    });

                    it(@"should call the completion block with appropriate data", ^{
                        expect(capturedResponseObject).to.equal(data);
                    });

                    context(@"when there's no error", ^{

                        beforeEach(^{
                            fixtureError = nil;
                        });

                        it(@"should have no error", ^{
                            expect(capturedError).to.beNil();
                        });
                    });

                    context(@"when there's an error", ^{

                        beforeEach(^{
                            fixtureError = [NSError errorWithDomain:@"Fixture Domain" code:42 userInfo:nil];
                        });

                        it(@"should pass the error", ^{
                            expect(capturedError).to.equal(fixtureError);
                        });
                    });
                });
            });
        });

        describe(@"when the request fails", ^{

            __block NSError *error;
            __block NSError *capturedError;

            __block NSURLResponse *capturedURLResponse;
            __block id capturedResponseObject;

            beforeEach(^{
                error = [NSError errorWithDomain:@"Fixture Domain" code:42 userInfo:nil];

                completion = ^(id o, NSURLResponse *response, NSError *completionError) {
                    capturedError = completionError;
                    capturedResponseObject = o;
                    capturedURLResponse = response;
                };
            });

            action(^{
                [delegate URLSession:mockSession task:mockTask didCompleteWithError:error];
            });

            it(@"should call the completion block with error", ^{
                expect(capturedError).to.equal(error);
            });

            it(@"should have the response", ^{
                expect(capturedResponseObject).to.equal([NSData new]);
            });

            it(@"should have the URL response", ^{
                expect(capturedURLResponse).to.equal(mockURLResponse);
            });
        });

        describe(@"when the request is cancelled", ^{

            action(^{
                [sut cancelRequestWithIdentifier:identifier];
            });

            it(@"should cancel underlying session task", ^{
                [verify(mockTask) cancel];
            });
        });
    });
});

SpecEnd
