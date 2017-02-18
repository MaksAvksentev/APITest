//
//  Constants.h
//  VKApiTest
//
//  Created by Maksim Avksentev on 16.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

static NSString *const authorizationVKrequest = @"https://oauth.vk.com/authorize?client_id=5873309&redirect_uri=https://oauth.vk.com/blank.html&display=mobile&scope=1030&response_type=token&v=5.62";

static NSString *const LoginToFriendsViewSegue = @"LoginToFriendsViewSegue";
static NSString *const FriendsViewToLoginSegue = @"FriendsViewToLoginSegue";

static NSString *logout = @"http://api.vk.com/oauth/logout";
static NSString *const baseURL =@"https://api.vk.com/method/";

static NSString *nameOfFriendCell = @"FriendCell";
static NSString *nameOfCurrentUserCell = @"CurrentUserCell";


static NSString *firstTimeAppear = @"firstTimeAppear";


#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define API_MANAGER [APIManager sharedManager]

#endif /* Constants_h */
