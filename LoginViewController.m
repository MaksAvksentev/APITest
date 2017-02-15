//
//  LoginViewController.m
//  APITest
//
//  Created by Maksim Avksentev on 13.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import "LoginViewController.h"
#import "AccessToken.h"
@interface LoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) LoginComplitionBlock complitionBlock;
@property (weak, nonatomic) UIWebView* webView;

@end

@implementation LoginViewController

- (id)initWithCompletionBlock:(LoginComplitionBlock) complitionBlock;
{
    self = [super init];
    if (self) {
        self.complitionBlock = complitionBlock;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    UIWebView* webView = [[UIWebView alloc] initWithFrame:rect];
    
    self.navigationItem.title = @"Login";

    [self.view addSubview:webView];
    
    NSString *urlString = @"https://oauth.vk.com/authorize?"
                            "client_id=5873309&"
                            "redirect_uri=https://oauth.vk.com/blank.html&"
                            "display=mobile&"
                            "scope=1030&"
                            "response_type=token&"
                            "v=5.62";
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    webView.delegate = self;
    self.webView = webView;
    
    [webView loadRequest:request];
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView    shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *query = [[request URL] description];
    NSArray *array = [query componentsSeparatedByString:@"#"];
    if ([[array firstObject] isEqualToString:@"https://oauth.vk.com/blank.html"]) {
        
        AccessToken *token = [[AccessToken alloc] init];
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString *pair in pairs) {
            
            NSArray *values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString *key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    
                    token.accessToken = [values lastObject];
                    
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    
                    token.expiresDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    token.userID = [values lastObject];
                }
            }
            
        }
        
        if (self.complitionBlock) {
            
            self.complitionBlock(token);
        }
        
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    
       
    }
    
    return YES;
}

@end
