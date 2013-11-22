//
//  ALHTTPSessionManager.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 19..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALSerialization.h"
#import "ALSessionManager.h"

@interface ALHTTPSessionManager : ALSessionManager

@property (nonatomic, strong) ALSerialization *serialization;

// ALHTTPSessionManager - Standard alone용
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler;
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler;
- (void)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler;
- (void)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler;

@end
