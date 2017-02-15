//
//  CurrentUserView.m
//  APITest
//
//  Created by Maksim Avksentev on 14.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import "CurrentUserTableCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@implementation CurrentUserTableCell

- (void)initWithUser:(User*)user
{
 
    self.displayLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    __weak CurrentUserTableCell* cell = self;

    [self.image setImageWithURLRequest:[NSURLRequest requestWithURL:user.imageURL] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        cell.image.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
    }];
    
    cell.image.layer.cornerRadius = 16.f;
    cell.image.clipsToBounds = YES;
}

@end
