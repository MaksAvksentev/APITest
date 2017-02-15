//
//  ServerManager.m
//  APITest
//
//  Created by Maksim Avksentev on 11.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "AccessToken.h"
#import "CurrentUserTableCell.h"
#import "UIImageView+AFNetworking.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;

@end

@implementation ServerManager

+ (ServerManager*)sharedManager{
    
    static ServerManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/friends.get"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void)getFriendsWithOffset:(NSInteger) offset
                       count:(NSInteger) count
                   onSuccess:(void(^)(NSArray* friends)) success
                    onFalier:(void(^)(NSError* error, NSInteger statusCode)) failure{

    NSDictionary *parameters = @{ @"user_id"    : self.accessToken.userID,
                                  @"order"      : @"hints",
                                  @"count"      : @(count),
                                  @"offset"     : @(offset),
                                  @"fields"     : @"photo_50",
                                  @"name_case"  : @"nom"};
    
    [self.sessionManager GET:@"https://api.vk.com/method/friends.get" parameters:parameters
    success:^(NSURLSessionDataTask *task, id responseObject){
        NSLog(@"%@",responseObject);
        NSArray* friendsArray = [responseObject objectForKey:@"response"];
        if (success) {
            success(friendsArray);
        }
    }
    failure:^(NSURLSessionDataTask *task, NSError *error){
        if (failure) {
            failure(error, 1);
        }
    }];

}

- (void)logOutSuccess:(void (^)())success onFailure:(void (^)(NSError *, NSInteger))failure{
   
    self.accessToken = nil;
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"vk.com"];
        
        if(domainRange.length > 0) {
            [storage deleteCookie:cookie];
        }
    }
     
    [self authorizeUser:nil];
}

- (void) authorizeUser:(void(^)(User *user))completion {

    self.currentUser = nil;
    self.accessToken = nil;
    
    LoginViewController* vc = [[LoginViewController alloc] initWithCompletionBlock:^(AccessToken *token) {
     
        self.accessToken = token;
        if (token) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.accessToken.userID forKey:@"CurrentUser"];
            [self getUser:self.accessToken.userID
             
                onSuccess:^(User *user) {
                    
                    if (completion) {
                        completion(user);
                    }
                    
                } onFailure:^(NSError *error, NSInteger statusCode) {
                    
                    if (completion) {
                        completion(nil);
                    }
                }];
            
        } else if (completion) {
            completion(nil);
        }    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIViewController* mainVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [mainVC presentViewController:nav animated:YES completion:nil];
}

- (void)getUser:(NSString *)userID onSuccess:(void (^)(User *))success onFailure:(void (^)(NSError *, NSInteger))failure{

    NSDictionary *parameters = @{ @"user_ids"   : userID,
                                  @"fields"     : @"photo_50",
                                  @"name_case"  : @"nom",
                                  @"v"          : @5.62 };
    [self.sessionManager GET:@"https://api.vk.com/method/users.get" parameters:parameters
                     success:^(NSURLSessionDataTask *task, id responseObject){
                         User *user = [[User alloc]
                                       initWithServerResponse:
                                       [[responseObject objectForKey:@"response"] firstObject]];
                         self.currentUser = user;
                         
                         if (success) {
                             success(user);
                         }
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error){
                         if (failure) {
                             failure(error, 1);
                         }
                     }];
}
@end
