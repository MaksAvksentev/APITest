//
//  User.h
//  APITest
//
//  Created by Maksim Avksentev on 13.02.17.
//  Copyright © 2017 Maksim Avksentev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString* status;

- (instancetype) initWithServerResponse:(NSDictionary *)response;

@end
