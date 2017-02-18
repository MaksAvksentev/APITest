//
//  FriendsViewController.h
//  VKApiTest
//
//  Created by Maksim Avksentev on 16.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *friendsArray;

- (IBAction)logout:(id)sender;

@end
