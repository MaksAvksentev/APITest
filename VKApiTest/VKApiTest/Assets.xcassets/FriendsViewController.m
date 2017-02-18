//
//  FriendsViewController.m
//  VKApiTest
//
//  Created by Maksim Avksentev on 16.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import "FriendsViewController.h"
#import "Constants.h"
#import "TableViewCurrentUserCell.h"
#import "TableViewFriendCell.h"
#import "APIManager.h"
#import "UserModel.h"
#import "UIImageView+AFNetworking.h"

@implementation FriendsViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self getCurrentUser];
    [self getFriendsFromServer];
}

- (void) getCurrentUser{

    [API_MANAGER getUser:[USER_DEFAULTS objectForKey:@"VKAccessUserId"] onSuccess:nil onFailure:nil];
}

- (void) getFriendsFromServer {
    
    self.friendsArray = [API_MANAGER getFriendsonSuccess:nil onFailure:nil];
    
    NSMutableArray *newPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.friendsArray count]; i++) {
        [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];

    
}

- (IBAction)logout:(id)sender {
    
        [USER_DEFAULTS removeObjectForKey:@"VKAccessUserId"];
        [USER_DEFAULTS removeObjectForKey:@"VKAccessToken"];
        [USER_DEFAULTS removeObjectForKey:@"VKAccessTokenDate"];
        [USER_DEFAULTS synchronize];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"vk.com"];
        
        if(domainRange.length > 0) {
            [storage deleteCookie:cookie];
            cookie = nil;
        }
    }
    
    [USER_DEFAULTS setObject:0 forKey:firstTimeAppear];
    [self performSegueWithIdentifier:FriendsViewToLoginSegue sender:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.friendsArray count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        TableViewCurrentUserCell *userCell = [self.tableView dequeueReusableCellWithIdentifier:nameOfCurrentUserCell];
        
        if (!userCell) {
            userCell = [[TableViewCurrentUserCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nameOfCurrentUserCell];
        }
        
        [userCell initInfoWithUser:[API_MANAGER currentUser]];
        
        return userCell;
        
    }else{
    
        TableViewFriendCell *friendCell = [self.tableView dequeueReusableCellWithIdentifier:nameOfFriendCell];

        if (!friendCell) {
            friendCell = [[TableViewFriendCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nameOfFriendCell];
        }

        [friendCell initInfoWithUser:[self.friendsArray objectAtIndex:indexPath.row-1]];
     
        return friendCell;

    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        return 150.f;
    }else {
    
        return 44.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
