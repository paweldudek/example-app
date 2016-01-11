#import "Specs.h"

#import "UserPresentationController.h"
#import "UserTableViewCell.h"
#import "User.h"
#import "NSManagedObject+SpecHelpers.h"
#import "Company.h"

SpecBegin(UserPresentationController)

describe(@"UserPresentationController", ^{

    __block UserPresentationController *sut;

    beforeEach(^{
        sut = [[UserPresentationController alloc] init];
    });

    afterEach(^{
        sut = nil;
    });

    it(@"should have appropriate estimated height", ^{
        expect(sut.estimatedCellHeight).to.equal(100);
    });

    describe(@"table view cell nib", ^{

        __block UINib *tableViewCellNib;

        action(^{
            tableViewCellNib = [sut tableViewCellNib];
        });

        it(@"should return users table view cell ni", ^{
            // We can't directly compare nibs, but we can check what's inside
            expect([tableViewCellNib instantiateWithOwner:nil options:nil].firstObject).to.beKindOf([UserTableViewCell class]);
        });
    });

    describe(@"configure cell", ^{

        IN_MEMORY_CORE_DATA

        __block UserTableViewCell *tableViewCell;
        __block User *user;

        beforeEach(^{
            user = [User specsEmptyObject];
            user.name = @"Fixture Name";
            user.email = @"fixture@email.com";
            user.company = [[Company alloc] initWithName:@"Fixture Company Name"
                                             catchphrase:@"Fixture Company Catchphrase"];

            tableViewCell = [[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
        });

        action(^{
            [sut configureTableViewCell:tableViewCell atIndexPath:nil withObject:user];
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

    describe(@"select object", ^{

        IN_MEMORY_CORE_DATA

        __block User *user;
        __block id mockDelegate;

        beforeEach(^{
            user = [User specsEmptyObject];

            mockDelegate = mockProtocol(@protocol(UserPresentationControllerDelegate));
            sut.delegate = mockDelegate;
        });

        action(^{
            [sut selectObject:user];
        });

        it(@"should inform its delegate that user was selected", ^{
            [verify(mockDelegate) userPresentationController:sut didSelectUser:user];
        });
    });
});

SpecEnd
