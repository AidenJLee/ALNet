//
//  ALConfiguration.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 20..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALConfiguration : NSObject

+ (NSURLSessionConfiguration *)customConfigurationForAuthorizationWithUser:(NSString *)user password:(NSString *)password;

@end
