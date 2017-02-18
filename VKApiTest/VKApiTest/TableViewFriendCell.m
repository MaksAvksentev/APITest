//
//  TableViewFriendCell.m
//  VKApiTest
//
//  Created by Maksim Avksentev on 16.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import "TableViewFriendCell.h"
#import "Constants.h"
#import "APIManager.h"
#import "UserModel.h"
#import "UIImageView+AFNetworking.h"

@implementation TableViewFriendCell


- (void)initInfoWithUser:(UserModel *) user{
    
    __weak TableViewFriendCell* cell = self;
    
    cell.textLabel.text = [user getFullName];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
   
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:user.imageURL] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
            cell.imageView.image = image;
            cell.imageView.clipsToBounds = YES;
            cell.imageView.layer.cornerRadius = cell.imageView.image.size.height / 2;
            [cell setNeedsLayout];
            [cell.imageView layoutSubviews];
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        cell.imageView.image = [UIImage imageNamed:@"fullhdtransparent.png"];
        [cell.imageView layoutSubviews];
    }];

}

@end
