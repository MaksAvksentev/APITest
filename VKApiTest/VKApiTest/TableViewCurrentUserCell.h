//
//  TableViewCurrentUserCell.h
//  VKApiTest
//
//  Created by Maksim Avksentev on 16.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  UserModel;

@interface TableViewCurrentUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCurrentUser;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentUser;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

- (void)initInfoWithUser:(UserModel *) user;

@end
