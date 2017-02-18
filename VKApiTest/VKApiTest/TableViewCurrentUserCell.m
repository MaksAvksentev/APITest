//
//  TableViewCurrentUserCell.m
//  VKApiTest
//
//  Created by Maksim Avksentev on 16.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import "TableViewCurrentUserCell.h"
#import "APIManager.h"
#import "Constants.h"
#import "UserModel.h"
#import "UIImageView+AFNetworking.h"

@implementation TableViewCurrentUserCell

- (void)initInfoWithUser:(UserModel *) user{
  
    __weak TableViewCurrentUserCell* cell = self;

    cell.labelCurrentUser.text = [user getFullName];
    
    [cell.imageViewCurrentUser setImageWithURLRequest:[NSURLRequest requestWithURL:user.imageURL] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        cell.imageViewCurrentUser.image = image;
        [cell.imageViewCurrentUser layoutSubviews];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
    }];
    
    cell.imageViewCurrentUser.layer.cornerRadius = cell.imageViewCurrentUser.frame.size.height / 2;
    cell.imageViewCurrentUser.clipsToBounds = YES;
}


@end
