#import "Specs.h"

#import "AlbumsPhotosUpdater.h"
#import "FixtureResponses.h"
#import "AlbumPhoto.h"
#import "NSManagedObject+Convenience.h"
#import "NSManagedObject+SpecHelpers.h"

SpecBegin(AlbumsPhotosUpdater)

describe(@"AlbumsPhotosUpdater", ^{

    __block AlbumsPhotosUpdater *sut;

    beforeEach(^{
        sut = [[AlbumsPhotosUpdater alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    describe(@"update content", ^{

        IN_MEMORY_CORE_DATA

        action(^{
            [sut updateContentWithArray:[FixtureResponses fixtureAlbumsPhotosResponse]
                   managedObjectContext:[NSManagedObjectContext specsManagedObjectContext]];
            [NSManagedObjectContext specSave];
            [NSManagedObjectContext specReset];
        });

        describe(@"all albums", ^{

            __block NSArray *albumsPhotos;

            action(^{
                albumsPhotos = [AlbumPhoto allFromContext:[NSManagedObjectContext specsManagedObjectContext]
                                                 sortedBy:@"identifier"];
            });

            context(@"when there were no albums in database before", ^{

                it(@"should have two albums", ^{
                    expect(albumsPhotos).to.haveCountOf(2);
                });

                describe(@"first album", ^{

                    __block AlbumPhoto *albumPhoto;

                    action(^{
                        albumPhoto = albumsPhotos[0];
                    });

                    it(@"should have a title", ^{
                        expect(albumPhoto.title).to.equal(@"Fixture Title 1");
                    });

                    it(@"should have an album identifier", ^{
                        expect(albumPhoto.albumIdentifier).to.equal(84);
                    });

                    it(@"should have thumbnail url", ^{
                        expect(albumPhoto.thumbnailUrl).to.equal([NSURL URLWithString:@"http://fixture1.com"]);
                    });

                    it(@"should have an identifier", ^{
                        expect(albumPhoto.identifier).to.equal(42);
                    });
                });

                describe(@"second album", ^{

                    __block AlbumPhoto *albumPhoto;

                    action(^{
                        albumPhoto = albumsPhotos[1];
                    });

                    it(@"should have a title", ^{
                        expect(albumPhoto.title).to.equal(@"Fixture Title 2");
                    });

                    it(@"should have an album identifier", ^{
                        expect(albumPhoto.albumIdentifier).to.equal(85);
                    });

                    it(@"should have thumbnail url", ^{
                        expect(albumPhoto.thumbnailUrl).to.equal([NSURL URLWithString:@"http://fixture2.com"]);
                    });

                    it(@"should have an identifier", ^{
                        expect(albumPhoto.identifier).to.equal(43);
                    });
                });
            });

            context(@"when there were albums in database before", ^{

                beforeEach(^{
                    AlbumPhoto *albumPhoto = [AlbumPhoto specsEmptyObject];
                    albumPhoto.identifier = @42;
                    [NSManagedObjectContext specSave];
                });

                it(@"should have two albums", ^{
                    expect(albumsPhotos).to.haveCountOf(2);
                });

                describe(@"first album", ^{

                    __block AlbumPhoto *albumPhoto;

                    action(^{
                        albumPhoto = albumsPhotos[0];
                    });

                    it(@"should have a title", ^{
                        expect(albumPhoto.title).to.equal(@"Fixture Title 1");
                    });

                    it(@"should have an album identifier", ^{
                        expect(albumPhoto.albumIdentifier).to.equal(84);
                    });

                    it(@"should have thumbnail url", ^{
                        expect(albumPhoto.thumbnailUrl).to.equal([NSURL URLWithString:@"http://fixture1.com"]);
                    });

                    it(@"should have an identifier", ^{
                        expect(albumPhoto.identifier).to.equal(42);
                    });
                });
            });

            context(@"when there were albums in database before that no longer exist on backend", ^{

                beforeEach(^{
                    AlbumPhoto *albumPhoto = [AlbumPhoto specsEmptyObject];
                    albumPhoto.identifier = @45;
                    [NSManagedObjectContext specSave];
                });

                it(@"should have two albums", ^{
                    expect(albumsPhotos).to.haveCountOf(2);
                });

                it(@"should delete album that no longer exists", ^{
                    AlbumPhoto *albumPhoto = [AlbumPhoto findFirstByIdentifier:@45
                                                                   fromContext:[NSManagedObjectContext specsManagedObjectContext]];
                    expect(albumPhoto).to.beNil();
                });
            });
        });
    });
});

SpecEnd
