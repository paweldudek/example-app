#import "Specs.h"

#import "AlbumPhotosProvider.h"
#import "AlbumController.h"
#import "PersistenceController.h"
#import "Album.h"
#import "NSManagedObject+SpecHelpers.h"

SpecBegin(AlbumPhotosProvider)

describe(@"AlbumPhotosProvider", ^{

    IN_MEMORY_CORE_DATA

    __block AlbumPhotosProvider *sut;
    __block Album *album;

     __block id mockAlbumController;
     __block id mockPersistenceController;

     beforeEach(^{
         mockAlbumController = mock([AlbumController class]);
         mockPersistenceController = mock([PersistenceController class]);

         [given([mockPersistenceController mainThreadManagedObjectContext]) willReturn:[NSManagedObjectContext specsManagedObjectContext]];

         album = [Album specsEmptyObject];
         album.title = @"Fixture Album Title";

         sut = [[AlbumPhotosProvider alloc] initWithAlbum:album
                                          albumController:mockAlbumController
                                    persistenceController:mockPersistenceController];

     });

     afterEach(^{
         sut = nil;
     });

     it(@"should have a title equal to album title", ^{
         expect(sut.title).to.equal(@"Fixture Album Title");
     });

     describe(@"update content", ^{

         __block id mockDelegate;

         beforeEach(^{
             mockDelegate = mockProtocol(@protocol(ContentProviderDelegate));
             sut.delegate = mockDelegate;
         });

         action(^{
             [sut updateContent];
         });

         it(@"should tell its delegate that it will begin updating data", ^{
             [verify(mockDelegate) contentProviderWillBeginUpdatingData:sut];
         });

         it(@"should tell its users controller to update users", ^{
             [verify(mockAlbumController) updateAlbumsPhotosWithCompletion:anything()];
         });

         describe(@"when updating finishes", ^{

             action(^{
                 HCArgumentCaptor *captor = [HCArgumentCaptor new];
                 [verify(mockAlbumController) updateAlbumsPhotosWithCompletion:(id) captor];

                 void (^completion)() = [captor value];
                 if (completion) {
                     completion();
                 }
             });

             it(@"should inform its delegate that it updated content", ^{
                 [verify(mockDelegate) contentProviderDidUpdateContent:sut];
             });

             it(@"should tell its delegate that it finished loading data", ^{
                 [verify(mockDelegate) contentProviderDidFinishUpdatingData:sut];
             });
         });
     });
});

SpecEnd
