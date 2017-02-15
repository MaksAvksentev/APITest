 //
//  ViewController.m
//  APITest
//
//  Created by Maksim Avksentev on 11.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import "ViewController.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "AccessToken.h"
#import "CurrentUserTableCell.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController ()

@property (strong,nonatomic) NSMutableArray* friendsArray;
@property (assign, nonatomic) BOOL firstTimeAppear;


@end

@implementation ViewController

static NSInteger friendInRequest = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTimeAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    ViewController* vc = [[ViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIViewController* mainVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [mainVC presentViewController:nav animated:YES completion:nil];

    
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.firstTimeAppear) {
        
        [[ServerManager sharedManager] authorizeUser:^(User *user) {
            NSLog(@"AUTHORIZED\n");
            NSLog(@"%@ %@\n\n", user.firstName, user.lastName);
        }];
        
        
        self.firstTimeAppear = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.friendsArray = nil;
    self.friendsArray = [[NSMutableArray alloc] init];
}

#pragma mark - Actions

- (IBAction)logOutAction:(UIBarButtonItem*)sender{

    [self dismissViewControllerAnimated:YES
                             completion:nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.firstTimeAppear = YES;
    [userDefaults setObject:nil forKey:@"CurrentUser"];
    [[ServerManager sharedManager] logOutSuccess:nil onFailure:nil];
}

#pragma mark - API
    
- (void)getFriendsFromServer {

    [[ServerManager sharedManager] getFriendsWithOffset:[self.friendsArray count]
                                                  count:friendInRequest
                                              onSuccess:^(NSArray *friends) {
                                                  [self.friendsArray addObjectsFromArray:friends];
                                                  NSMutableArray *newPaths = [NSMutableArray array];
                                                  for (int i = (int)[self.friendsArray count] - (int)[friends count]; i<[self.friendsArray count] ; i++) {
                                                      [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                                  }
                                                  [self.tableView beginUpdates];
                                                  [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                                                  [self.tableView endUpdates];
                                              }
                                               onFalier:^(NSError *error, NSInteger statusCode) {
                                                   NSLog(@"%@ %ld",[error localizedDescription], (long)statusCode);
                                               }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.friendsArray count] + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if(indexPath.row == 0){
        
        static NSString *userIdentifier = @"UserCell";

        CurrentUserTableCell *cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"CurrentUser"] ) {
            
        [[ServerManager sharedManager] getUser:[userDefaults objectForKey:@"CurrentUser"] onSuccess:nil onFailure:nil];
        [cell initWithUser:[[ServerManager sharedManager]currentUser]];
        }
        return cell;
        
    }else{
        
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
        if (indexPath.row == [self.friendsArray count] + 1) {
            
            cell.textLabel.text = @"Load more";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.imageView.image = nil;
            [self tableView:tableView editingStyleForRowAtIndexPath:indexPath];
            
        }
        else {
            
            User *user = [[User alloc] initWithServerResponse:[self.friendsArray objectAtIndex:indexPath.row - 1]];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",  user.firstName, user.lastName];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            
            __weak UITableViewCell *weakCell = cell;
            
            [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:user.imageURL]
                                  placeholderImage:nil
             
                                           success:^(NSURLRequest * _Nonnull request,
                                                     NSHTTPURLResponse * _Nullable response,
                                                     UIImage * _Nonnull image) {
                                               
                                               weakCell.imageView.image = image;
                                               [weakCell layoutSubviews];
                                               
                                           }
                                           failure:^(NSURLRequest * _Nonnull request,
                                                     NSHTTPURLResponse * _Nullable response,
                                                     NSError * _Nonnull error) {
                                               
                                               weakCell.imageView.image = [UIImage imageNamed:@"cross"];
                                               [weakCell layoutSubviews];
                                               
                                           }];
            cell.imageView.layer.cornerRadius = 12.f;
            cell.imageView.clipsToBounds = YES;
        }
        
        return cell;
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == [self.friendsArray count] || indexPath.row == 0) {
        
        return UITableViewCellEditingStyleNone;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.friendsArray count] + 1 == indexPath.row) {
        [self getFriendsFromServer];
    }
}

@end
