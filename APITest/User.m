
//
//  User.m
//  APITest
//
//  Created by Maksim Avksentev on 13.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        
        self.firstName = [response objectForKey:@"first_name"];
        self.lastName = [response objectForKey:@"last_name"];
        self.imageURL = [NSURL URLWithString:[response objectForKey:@"photo_50"]];
        
    }
    return self;
}

@end
