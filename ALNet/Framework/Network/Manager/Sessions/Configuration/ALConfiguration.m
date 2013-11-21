//
//  ALConfiguration.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 20..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALConfiguration.h"

@implementation ALConfiguration

+ (NSURLSessionConfiguration *)customConfigurationForAuthorizationWithUser:(NSString *)user password:(NSString *)password
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *userPasswordString = [NSString stringWithFormat:@"%@:%@", user, password];
    NSData * userPasswordData = [userPasswordString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedCredential = [userPasswordData base64EncodedStringWithOptions:0];
    NSString *authString = [NSString stringWithFormat:@"Basic: %@", base64EncodedCredential];
    NSString *userAgentString = @"AppName/com.entist.app (iPhone 5; iOS 7.0.2; Scale/2.0)";
    
    configuration.HTTPAdditionalHeaders = @{
                                                @"Accept": @"application/json",
                                                @"Accept-Language": @"en",
                                                @"Authorization": authString,
                                                @"User-Agent": userAgentString
                                            };
    return configuration;
}

@end
