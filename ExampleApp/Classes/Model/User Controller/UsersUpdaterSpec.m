#import "Specs.h"

#import "UsersUpdater.h"
#import "NSManagedObjectContext+SpecHelpers.h"
#import "FixtureResponses.h"
#import "User.h"
#import "NSManagedObject+Convenience.h"
#import "NSManagedObject+SpecHelpers.h"

SpecBegin(UsersUpdater)

describe(@"UsersUpdater", ^{

    __block UsersUpdater *sut;

    beforeEach(^{
        sut = [[UsersUpdater alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    describe(@"", ^{

        IN_MEMORY_CORE_DATA

        action(^{
            [sut updateUsersWithResponse:[FixtureResponses fixtureUsersResponse]
                    managedObjectContext:[NSManagedObjectContext specsManagedObjectContext]];
            [NSManagedObjectContext specSave];
            [NSManagedObjectContext specReset];
        });

        describe(@"all users", ^{

            __block NSArray *users;

            action(^{
                users = [User allFromContext:[NSManagedObjectContext specsManagedObjectContext]
                                    sortedBy:@"identifier"];
            });

            context(@"when there were no users in database before", ^{

                it(@"should have two users", ^{
                    expect(users).to.haveCountOf(2);
                });

                describe(@"first user", ^{

                    __block User *user;

                    action(^{
                        user = users[0];
                    });

                    it(@"should have a name", ^{
                        expect(user.name).to.equal(@"Fixture Name 1");
                    });

                    it(@"should have an email", ^{
                        expect(user.email).to.equal(@"fixutre@email1.com");
                    });

                    it(@"should have an identifier", ^{
                        expect(user.identifier).to.equal(42);
                    });
                });

                describe(@"second user", ^{

                    __block User *user;

                    action(^{
                        user = users[1];
                    });

                    it(@"should have a name", ^{
                        expect(user.name).to.equal(@"Fixture Name 2");
                    });

                    it(@"should have an email", ^{
                        expect(user.email).to.equal(@"fixutre@email2.com");
                    });

                    it(@"should have an identifier", ^{
                        expect(user.identifier).to.equal(43);
                    });
                });
            });

            context(@"when there were users in database before", ^{

                beforeEach(^{
                    User *user = [User specsEmptyObject];
                    user.identifier = @42;
                    [NSManagedObjectContext specSave];
                });

                it(@"should have two users", ^{
                    expect(users).to.haveCountOf(2);
                });

                describe(@"first user", ^{

                    __block User *user;

                    action(^{
                        user = users[0];
                    });

                    it(@"should have a name", ^{
                        expect(user.name).to.equal(@"Fixture Name 1");
                    });

                    it(@"should have an email", ^{
                        expect(user.email).to.equal(@"fixutre@email1.com");
                    });

                    it(@"should have an identifier", ^{
                        expect(user.identifier).to.equal(42);
                    });
                });
            });

            context(@"when there were users in database before that no longer exist on backend", ^{

                beforeEach(^{
                    User *user = [User specsEmptyObject];
                    user.identifier = @45;
                    [NSManagedObjectContext specSave];
                });

                it(@"should have two users", ^{
                    expect(users).to.haveCountOf(2);
                });

                it(@"should delete user that no longer exists", ^{
                    User *user = [User findFirstByIdentifier:@45
                                                 fromContext:[NSManagedObjectContext specsManagedObjectContext]];
                    expect(user).to.beNil();
                });
            });
        });
    });
});

SpecEnd
