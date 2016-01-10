#import "Specs.h"

#import "UsersViewController.h"
#import "NSManagedObjectContext+SpecHelpers.h"
#import "NSManagedObject+SpecHelpers.h"
#import "User.h"
#import "ContainerView.h"
#import "UserTableViewCell.h"
#import "Company.h"

SpecBegin(UsersViewController)

describe(@"UsersViewController", ^{

    __block UsersViewController *sut;

    __block id mockUsersProvider;

    beforeEach(^{
        mockUsersProvider = mockProtocol(@protocol(UsersProvider));
        sut = [[UsersViewController alloc] initWithUsersProvider:mockUsersProvider];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should set itself as delegate of the users provider", ^{
        [verify(mockUsersProvider) setDelegate:sut];
    });

    it(@"should define presentation context", ^{
        expect(sut.definesPresentationContext).to.beTruthy();
    });

    describe(@"view", ^{

        __block ContainerView *view;

        action(^{
            view = (ContainerView *) [sut view];
        });

        it(@"should be a container view", ^{
            expect(view).to.beKindOf([ContainerView class]);
        });

        it(@"should tell its users provider to update content", ^{
            [verify(mockUsersProvider) updateContent];
        });

        describe(@"child view controllers", ^{

            __block NSArray *childViewControllers;

            action(^{
                childViewControllers = [sut childViewControllers];
            });

            it(@"should have one child view controller", ^{
                expect(childViewControllers).to.haveCountOf(1);
            });

            describe(@"first child view controller", ^{

                __block UITableViewController *tableViewController;

                action(^{
                    tableViewController = childViewControllers.firstObject;
                });

                it(@"should be a table view controller", ^{
                    expect(tableViewController).to.beKindOf([UITableViewController class]);
                });

                it(@"should have its table views delegate set", ^{
                    expect(tableViewController.tableView.delegate).to.equal(sut);
                });

                it(@"should have its table views data source set", ^{
                    expect(tableViewController.tableView.dataSource).to.equal(sut);
                });

                it(@"should have its view set as containers view content view", ^{
                    expect(view.containedView).to.equal(tableViewController.view);
                });
            });
        });
    });

    describe(@"table view delegate and data source", ^{

        describe(@"cell for row at index path", ^{

            IN_MEMORY_CORE_DATA

            __block NSIndexPath *indexPath;

            __block UserTableViewCell *tableViewCell;

            beforeEach(^{
                User *user = [User specsEmptyObject];
                user.name = @"Fixture Name";
                user.email = @"fixture@email.com";
                user.company = [[Company alloc] initWithName:@"Fixture Company Name"
                                                 catchphrase:@"Fixture Company Catchphrase"];
                [given([mockUsersProvider userAtIndex:1]) willReturn:user];
                [given([mockUsersProvider numberOfUsers]) willReturnInteger:2];

                sut.view.frame = CGRectMake(0, 0, 320, 480);
                [sut.view layoutIfNeeded];

                indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            });

            action(^{
                tableViewCell = (UserTableViewCell *) [sut tableView:sut.tableView cellForRowAtIndexPath:indexPath];
            });

            it(@"should be a table view cell", ^{
                expect(tableViewCell).to.beKindOf([UserTableViewCell class]);
            });

            it(@"should have title with user name", ^{
                expect(tableViewCell.nameLabel.text).to.equal(@"Fixture Name");
            });

            it(@"should have user email as email label text", ^{
                expect(tableViewCell.emailLabel.text).to.equal(@"fixture@email.com");
            });

            it(@"should have company catchphrase as company catchphrase label text", ^{
                expect(tableViewCell.companyCatchPhraseLabel.text).to.equal(@"Fixture Company Catchphrase");
            });
        });
        
        describe(@"did select item at index path", ^{
            
            IN_MEMORY_CORE_DATA

            __block User *user;
            __block id mockDelegate;

            beforeEach(^{
                mockDelegate = mockProtocol(@protocol(UsersViewControllerDelegate));
                sut.delegate = mockDelegate;
                user = [User specsEmptyObject];
                [given([mockUsersProvider userAtIndex:1]) willReturn:user];
            });

            action(^{
                [sut tableView:mock([UITableView class]) didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1
                                                                                                    inSection:0]];
            });

            it(@"should inform its delegate that given user was selected", ^{
                [verify(mockDelegate) usersViewController:sut didSelectUser:user];
            });
        });

        describe(@"number of items", ^{

            __block NSInteger numberOfRowsInSection;

            beforeEach(^{
                [given([mockUsersProvider numberOfUsers]) willReturnInteger:42];
            });

            action(^{
                numberOfRowsInSection = [sut tableView:mock([UITableView class]) numberOfRowsInSection:0];
            });

            it(@"should return number of users from its content provider", ^{
                expect(numberOfRowsInSection).to.equal(42);
            });
        });
    });

    describe(@"content view provider delegate", ^{
        describe(@"did update content", ^{

            __block UITableView *tableView;

            beforeEach(^{
                [given([mockUsersProvider numberOfUsers]) willReturnInteger:2];

                sut.view.frame = CGRectMake(0, 0, 320, 480);
                [sut.view layoutIfNeeded];

                tableView = sut.tableView;

                expect([tableView numberOfRowsInSection:0]).to.equal(2);
            });

            action(^{
                [given([mockUsersProvider numberOfUsers]) willReturnInteger:5];
                [sut contentProviderDidUpdateContent:nil];
            });

            it(@"should reload the table view", ^{
                expect([tableView numberOfRowsInSection:0]).to.equal(5);
            });
        });
    });
});

SpecEnd
