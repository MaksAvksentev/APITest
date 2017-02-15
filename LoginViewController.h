//
//  LoginViewController.h
//  APITest
//
//  Created by Maksim Avksentev on 13.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccessToken;

typedef void(^LoginComplitionBlock)(AccessToken* token);

@interface LoginViewController : UIViewController

- (id)initWithCompletionBlock:(LoginComplitionBlock) complitionBlock;

@end
