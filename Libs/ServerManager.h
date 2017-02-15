//
//  ServerManager.h
//  APITest
//
//  Created by Maksim Avksentev on 11.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@class AccessToken;

@interface ServerManager : NSObject

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) AccessToken* accessToken;

+ (ServerManager*)sharedManager;

- (void)authorizeUser:(void(^)(User *user))completion;
- (void)logOutSuccess:(void (^)())success onFailure:(void (^)(NSError *, NSInteger))failure;

- (void)getUser:(NSString *)userID
       onSuccess:(void(^)(User *user))success
       onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                        onSuccess:(void(^)(NSArray* friends)) success
                        onFalier:(void(^)(NSError* error, NSInteger statusCode)) failure;


@end
