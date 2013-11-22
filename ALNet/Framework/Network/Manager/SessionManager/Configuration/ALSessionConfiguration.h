//
//  ALSessionConfiguration.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 22..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALNetConst.h"

@interface ALSessionConfiguration : NSObject

+ (NSURLSessionConfiguration *)defaultConfiguration;
+ (NSURLSessionConfiguration *)backgroundConfiguration;
+ (NSURLSessionConfiguration *)customConfigurationForAuthorizationWithUser:(NSString *)user password:(NSString *)password;

@end
