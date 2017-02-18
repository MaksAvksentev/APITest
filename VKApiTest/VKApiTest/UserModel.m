//
//  UserModel.m
//  VKApiTest
//
//  Created by Maksim Avksentev on 16.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


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

- (NSString *)getFullName{
    
    return [NSString stringWithFormat:@"%@ %@", self.firstName,self.lastName];
}
@end
