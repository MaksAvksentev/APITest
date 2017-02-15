//
//  CurrentUserView.h
//  APITest
//
//  Created by Maksim Avksentev on 14.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface CurrentUserTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UIImageView* image;
- (void)initWithUser:(User*)user;

@end
