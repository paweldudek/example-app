#import "Specs.h"

#import "ImageController.h"
#import "NSFileManager+ExampleApp.h"

SpecBegin(ImageController)

describe(@"ImageController", ^{

    __block ImageController *sut;

    beforeEach(^{
        sut = [[ImageController alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    describe(@"retrieve image with completion", ^{

        __block id mockImageEntity;
        __block void (^completionBlock)(id <FICEntity>, NSString *, UIImage *);
        __block id mockImageCache;

        beforeEach(^{
            mockImageEntity = mockProtocol(@protocol(FICEntity));
            completionBlock = ^(id <FICEntity> entity, NSString *formatName, UIImage *image) {

            };

            mockImageCache = mock([FICImageCache class]);
            sut.imageCache = mockImageCache;
        });

        action(^{
            [sut retrieveImageForEntity:mockImageEntity
                         withFormatName:@"Fixture Format Name"
                        completionBlock:completionBlock];
        });

        it(@"should tell its image cache to retrieve that image", ^{
            [verify(mockImageCache) asynchronouslyRetrieveImageForEntity:mockImageEntity
                                                          withFormatName:@"Fixture Format Name"
                                                         completionBlock:completionBlock];
        });
    });

    describe(@"image cache delegate", ^{

        __block id mockImageEntity;
        __block id mockSession;
        __block UIImage *capturedImage;

        beforeEach(^{
            mockImageEntity = mockProtocol(@protocol(FICEntity));
            NSURL *url = [NSURL URLWithString:@"http://fixture.com"];

            [given([mockImageEntity sourceImageURLWithFormatName:@"Fixture Format Name"]) willReturn:url];

            mockSession = mock([NSURLSession class]);
            sut.session = mockSession;
        });

        action(^{
            [sut imageCache:nil
  wantsSourceImageForEntity:mockImageEntity
             withFormatName:@"Fixture Format Name"
            completionBlock:^(UIImage *sourceImage) {
                capturedImage = sourceImage;
            }];
        });

        describe(@"last session request", ^{

            __block NSURLRequest *request;
            __block void (^completion)(NSURL *, NSURLResponse *, NSError *);

            action(^{
                HCArgumentCaptor *requestCaptor = [HCArgumentCaptor new];
                HCArgumentCaptor *completionCaptor = [HCArgumentCaptor new];

                [verify(mockSession) downloadTaskWithRequest:(id) requestCaptor
                                           completionHandler:(id) completionCaptor];

                request = [requestCaptor value];
                completion = [completionCaptor value];
            });

            it(@"should make a request to the source image URL", ^{
                expect(request.URL).to.equal([NSURL URLWithString:@"http://fixture.com"]);
            });

            describe(@"when it completes", ^{

                __block NSURL *temporaryURL;
                __block NSData *data;

                beforeEach(^{
                    temporaryURL = [[[NSFileManager defaultManager] generateNewTemporaryDirectoryURL] URLByAppendingPathComponent:@"test"];
                    NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test" ofType:@"png"];
                    UIImage *image = [UIImage imageWithContentsOfFile:resourcePath];
                    data = UIImagePNGRepresentation(image);
                    [data writeToURL:temporaryURL atomically:YES];
                });

                action(^{
                    if (completion) {
                        completion(temporaryURL, nil, nil);
                    }
                });

                afterEach(^{
                    [[NSFileManager defaultManager] removeItemAtURL:temporaryURL error:nil];
                });

                it(@"should call the completion with the downloaded image", ^{
                    expect(UIImagePNGRepresentation(capturedImage)).to.equal(data);
                });
            });
        });
    });
});

SpecEnd
