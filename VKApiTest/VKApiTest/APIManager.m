//
//  APIManager.m
//  VKApiTest
//
//  Created by Maksim Avksentev on 16.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import "APIManager.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "UserModel.h"

@interface APIManager ()

@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;

@end

@implementation APIManager
@synthesize currentUser;
+ (APIManager*)sharedManager {
    
    static APIManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[APIManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    static APIManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    
    return sharedInstance;
}

- (id)copy {
    
    return self;
}



- (void) authorizeUser:(NSString *)absoluteRequest {

    NSString *accessToken = [self stringBetweenString:@"access_token="
                                            andString:@"&"
                                          innerString:absoluteRequest];
                             
    NSArray *userAr = [absoluteRequest componentsSeparatedByString:@"&user_id="];
    NSString *user_id = [userAr lastObject];
    NSLog(@"User id: %@", user_id);
    if(user_id){
        [USER_DEFAULTS setObject:user_id forKey:@"VKAccessUserId"];
        
    }
    
    if(accessToken){
        [USER_DEFAULTS setObject:accessToken forKey:@"VKAccessToken"];
        [USER_DEFAULTS setObject:[NSDate date] forKey:@"VKAccessTokenDate"];
        [USER_DEFAULTS synchronize];
    }
}

- (UserModel *)getUser:(NSString *)userID onSuccess:(void (^)(UserModel *))success onFailure:(void (^)(NSError *, NSInteger))failure{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{ @"user_ids"       : userID,
                                  @"fields"         : @"photo_50",
                                  @"name_case"      : @"nom",
                                  @"lang"           : @"ru",
                                  @"https"          : @1,
                                  @"access_token"   : [USER_DEFAULTS objectForKey:@"VKAccessToken"],
                                  @"v"              : @5.62 }];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                          URLString:@"https://api.vk.com/method/users.get"
                                                                         parameters:parameters
                                                                              error:nil];
    
    NSDictionary *response = [[[self sendRequest:request] objectForKey:@"response"] firstObject];
    UserModel *user = [[UserModel alloc] initWithServerResponse:response];
    
    if (userID == [USER_DEFAULTS objectForKey:@"VKAccessUserId"]) {
        self.currentUser = user;
        return nil;
    }
    
    return user;
}

- (NSDictionary *) sendRequest:(NSMutableURLRequest *)request {

    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    id data = [NSJSONSerialization JSONObjectWithData:responseData
                                              options:0
                                                error:nil];
    return data;
}

- (NSMutableArray *)getFriendsonSuccess:(void(^)(NSArray *friends))success onFailure:(void(^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *parameters = @{ @"user_id"        : [USER_DEFAULTS objectForKey:@"VKAccessUserId"],
                                  @"order"          : @"hints",
                                  @"fields"         : @"photo_50",
                                  @"name_case"      : @"nom",
                                  @"lang"           : @"ru",
                                  @"https"          : @1,
                                  @"access_token"   : [USER_DEFAULTS objectForKey:@"VKAccessToken"],
                                  @"v"              : @5.62 };
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                          URLString:@"https://api.vk.com/method/friends.get"
                                                                         parameters:parameters
                                                                              error:nil];
    NSDictionary *response = [[self sendRequest:request] objectForKey:@"response"];
    
    NSArray *itemsArray = [response objectForKey:@"items"];
    NSMutableArray *friendsArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in itemsArray) {
        UserModel *user = [[UserModel alloc] initWithServerResponse:item];
        [friendsArray addObject:user];
    }
    return friendsArray;
}

#pragma mark - Methods

- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end innerString:(NSString*)str {
    
        NSScanner* scanner = [NSScanner scannerWithString:str];
        [scanner setCharactersToBeSkipped:nil];
        [scanner scanUpToString:start intoString:NULL];
    
        if ([scanner scanString:start intoString:NULL]) {
            NSString* result = nil;
            
            if ([scanner scanUpToString:end intoString:&result]) {
                
                return result;
            }
        }
    
        return nil;
    }
@end
