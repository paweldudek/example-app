/*
* Copyright (c) 2016 Paweł Dudek. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UserTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *nameLabel;

@property(nonatomic, strong) IBOutlet UILabel *emailLabel;

@property(nonatomic, strong) IBOutlet UILabel *companyCatchPhraseLabel;

@end
