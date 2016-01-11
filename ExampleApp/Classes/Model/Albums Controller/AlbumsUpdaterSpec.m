#import "Specs.h"

#import "AlbumsUpdater.h"
#import "FixtureResponses.h"
#import "Album.h"
#import "NSManagedObject+Convenience.h"
#import "NSManagedObject+SpecHelpers.h"

SpecBegin(AlbumsUpdater)

describe(@"AlbumsUpdater", ^{

    __block AlbumsUpdater *sut;

    beforeEach(^{
        sut = [[AlbumsUpdater alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    describe(@"update content", ^{

        IN_MEMORY_CORE_DATA

        action(^{
            [sut updateContentWithArray:[FixtureResponses fixtureAlbumsResponse]
                   managedObjectContext:[NSManagedObjectContext specsManagedObjectContext]];
            [NSManagedObjectContext specSave];
            [NSManagedObjectContext specReset];
        });

        describe(@"all albums", ^{

            __block NSArray *albums;

            action(^{
                albums = [Album allFromContext:[NSManagedObjectContext specsManagedObjectContext]
                                      sortedBy:@"identifier"];
            });

            context(@"when there were no albums in database before", ^{

                it(@"should have two albums", ^{
                    expect(albums).to.haveCountOf(2);
                });

                describe(@"first album", ^{

                    __block Album *album;

                    action(^{
                        album = albums[0];
                    });

                    it(@"should have a title", ^{
                        expect(album.title).to.equal(@"Fixture Title 1");
                    });

                    it(@"should have an user identifier", ^{
                        expect(album.userIdentifier).to.equal(84);
                    });

                    it(@"should have an identifier", ^{
                        expect(album.identifier).to.equal(42);
                    });
                });

                describe(@"second album", ^{

                    __block Album *album;

                    action(^{
                        album = albums[1];
                    });

                    it(@"should have a title", ^{
                        expect(album.title).to.equal(@"Fixture Title 2");
                    });

                    it(@"should have an user identifier", ^{
                        expect(album.userIdentifier).to.equal(85);
                    });

                    it(@"should have an identifier", ^{
                        expect(album.identifier).to.equal(43);
                    });
                });
            });

            context(@"when there were albums in database before", ^{

                beforeEach(^{
                    Album *album = [Album specsEmptyObject];
                    album.identifier = @42;
                    [NSManagedObjectContext specSave];
                });

                it(@"should have two albums", ^{
                    expect(albums).to.haveCountOf(2);
                });

                describe(@"first album", ^{

                    __block Album *album;

                    action(^{
                        album = albums[0];
                    });

                    it(@"should have a title", ^{
                        expect(album.title).to.equal(@"Fixture Title 1");
                    });

                    it(@"should have an user identifier", ^{
                        expect(album.userIdentifier).to.equal(84);
                    });

                    it(@"should have an identifier", ^{
                        expect(album.identifier).to.equal(42);
                    });
                });
            });

            context(@"when there were albums in database before that no longer exist on backend", ^{

                beforeEach(^{
                    Album *album = [Album specsEmptyObject];
                    album.identifier = @45;
                    [NSManagedObjectContext specSave];
                });

                it(@"should have two albums", ^{
                    expect(albums).to.haveCountOf(2);
                });

                it(@"should delete album that no longer exists", ^{
                    Album *album = [Album findFirstByIdentifier:@45
                                                 fromContext:[NSManagedObjectContext specsManagedObjectContext]];
                    expect(album).to.beNil();
                });
            });
        });
    });
});

SpecEnd
