#import "Specs.h"

#import "TableContentViewController.h"
#import "NSManagedObjectContext+SpecHelpers.h"
#import "NSManagedObject+SpecHelpers.h"
#import "User.h"
#import "ContainerView.h"
#import "UserTableViewCell.h"
#import "Company.h"
#import "LoadingView.h"
#import "TableContentPresentationController.h"

SpecBegin(TableContentViewController)

describe(@"TableContentViewController", ^{

    __block TableContentViewController *sut;

    __block id mockContentProvider;
    __block id mockPresentationController;

    beforeEach(^{
        mockContentProvider = mockProtocol(@protocol(ContentProvider));
        mockPresentationController = mockProtocol(@protocol(TableContentPresentationController));
        sut = [[TableContentViewController alloc] initWithContentProvider:mockContentProvider
                                       tableContentPresentationController:mockPresentationController];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should set itself as delegate of the users provider", ^{
        [verify(mockContentProvider) setDelegate:sut];
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
            [verify(mockContentProvider) updateContent];
        });

        it(@"should give the table view to presentation controller", ^{
            [verify(mockPresentationController) setTableView:sut.tableView];
        });

        describe(@"overlay view", ^{

            __block UIView *overlayView;

            action(^{
                overlayView = [view overlayView];
            });

            it(@"should be a loading view", ^{
                expect(overlayView).to.beKindOf([LoadingView class]);
            });

            it(@"should have no alpha", ^{
                expect(overlayView.alpha).to.equal(0.0f);
            });
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

            __block UITableViewCell *tableViewCell;
            __block User *user;

            beforeEach(^{
                user = [User specsEmptyObject];
                [given([mockContentProvider objectAtIndex:1]) willReturn:user];
                [given([mockContentProvider numberOfObjects]) willReturnInteger:2];

                [given([mockPresentationController tableViewCellNib]) willReturn:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil]];

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

            it(@"should tell its presentation controller to configure that cell", ^{
                [verify(mockPresentationController) configureTableViewCell:tableViewCell
                                                               atIndexPath:indexPath
                                                                withObject:user];
            });
        });
        
        describe(@"did select item at index path", ^{
            
            IN_MEMORY_CORE_DATA

            __block User *user;

            beforeEach(^{
                user = [User specsEmptyObject];
                [given([mockContentProvider objectAtIndex:1]) willReturn:user];
            });

            action(^{
                [sut tableView:mock([UITableView class]) didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1
                                                                                                    inSection:0]];
            });

            it(@"should inform its presentation controller that given object was selected", ^{
                [verify(mockPresentationController) selectObject:user];
            });
        });

        describe(@"number of items", ^{

            __block NSInteger numberOfRowsInSection;

            beforeEach(^{
                [given([mockContentProvider numberOfObjects]) willReturnInteger:42];
            });

            action(^{
                numberOfRowsInSection = [sut tableView:mock([UITableView class]) numberOfRowsInSection:0];
            });

            it(@"should return number of users from its content provider", ^{
                expect(numberOfRowsInSection).to.equal(42);
            });
        });

        describe(@"estimated height", ^{

            __block CGFloat estimatedHeightForRowAtIndexPath;

            beforeEach(^{
                [given([mockPresentationController estimatedCellHeight]) willReturnFloat:42];
            });

            action(^{
                estimatedHeightForRowAtIndexPath = [sut tableView:mock([UITableView class]) estimatedHeightForRowAtIndexPath:[NSIndexPath new]];
            });

            it(@"should return number of users from its content provider", ^{
                expect(estimatedHeightForRowAtIndexPath).to.equal(42);
            });
        });
    });

    describe(@"content view provider delegate", ^{

        describe(@"did update content", ^{

            __block UITableView *tableView;

            beforeEach(^{
                [given([mockContentProvider numberOfObjects]) willReturnInteger:2];
                [given([mockPresentationController tableViewCellNib]) willReturn:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil]];

                sut.view.frame = CGRectMake(0, 0, 320, 480);
                [sut.view layoutIfNeeded];

                tableView = sut.tableView;

                expect([tableView numberOfRowsInSection:0]).to.equal(2);
            });

            action(^{
                [given([mockContentProvider numberOfObjects]) willReturnInteger:5];
                [sut contentProviderDidUpdateContent:nil];
            });

            it(@"should reload the table view", ^{
                expect([tableView numberOfRowsInSection:0]).to.equal(5);
            });
        });
    });
});

SpecEnd
