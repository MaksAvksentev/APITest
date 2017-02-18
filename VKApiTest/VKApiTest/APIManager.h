//
//  APIManager.h
//  VKApiTest
//
//  Created by Maksim Avksentev on 16.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@interface APIManager : NSObject

@property (strong, nonatomic) UserModel *currentUser;

+ (APIManager*)sharedManager;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copy;

- (void) authorizeUser:(NSString *)absoluteRequest;

- (UserModel *)getUser:(NSString *)userID onSuccess:(void (^)(UserModel *))success onFailure:(void (^)(NSError *, NSInteger))failure;

- (NSMutableArray *)getFriendsonSuccess:(void(^)(NSArray *friends))success onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

@end
