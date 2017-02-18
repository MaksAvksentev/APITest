//
//  TableViewFriendCell.h
//  VKApiTest
//
//  Created by Maksim Avksentev on 16.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;

@interface TableViewFriendCell : UITableViewCell

- (void)initInfoWithUser:(UserModel *) user;

@end
