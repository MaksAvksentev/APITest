//
//  LoginViewController.m
//  VKApiTest
//
//  Created by Maksim Avksentev on 16.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "APIManager.h"


@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [USER_DEFAULTS setObject:false forKey:firstTimeAppear];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authorizationVKrequest]];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if ([self.webView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound) {
        
        NSString *absoluteRequest = [[[webView request] URL] absoluteString];
        [API_MANAGER authorizeUser:absoluteRequest];
        [self performSegueWithIdentifier:LoginToFriendsViewSegue sender:self];
    }
}

@end
