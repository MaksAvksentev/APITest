//
//  AccessToken.h
//  APITest
//
//  Created by Maksim Avksentev on 13.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject

@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) NSDate* expiresDate;
@property (strong, nonatomic) NSString* userID;

@end
