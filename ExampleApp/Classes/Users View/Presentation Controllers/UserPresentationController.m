/*
 * Copyright (c) 2016 Paweł Dudek. All rights reserved.
 */
#import "UserPresentationController.h"
#import "UserTableViewCell.h"
#import "User.h"
#import "Company.h"


@implementation UserPresentationController

- (UINib *)tableViewCellNib {
    return [UINib nibWithNibName:@"UserTableViewCell" bundle:nil];
}

- (CGFloat)estimatedCellHeight {
    return 100;
}

- (void)configureTableViewCell:(UserTableViewCell *)userTableViewCell withObject:(User *)user {
    userTableViewCell.nameLabel.text = user.name;
    userTableViewCell.emailLabel.text = user.email;
    userTableViewCell.companyCatchPhraseLabel.text = user.company.catchphrase;
}

- (void)selectObject:(id)object {
    [self.delegate userPresentationController:self didSelectUser:object];
}

@end
