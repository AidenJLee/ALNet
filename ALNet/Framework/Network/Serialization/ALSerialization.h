//
//  ALSerialization.h
//  AIDENJLEENetworking
//
//  Created by HoJun Lee on 2013. 11. 12..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALNetConst.h"

@interface ALSerialization : NSObject

@property (nonatomic, strong) NSIndexSet *statusCodes;


- (id)objectForResponse:(NSURLResponse *)response data:(NSData *)data;

- (NSMutableURLRequest *)requestWithURL:(NSURL *)URL
                             httpMethod:(NSString *)method
                             parameters:(NSDictionary *)parameters;

#pragma mark -
#pragma mark JSON Parsing Method
+ (id)objectFromJSONData:(NSData *)data;
+ (id)objectFromJSONString:(NSString *)JSONString;


#pragma mark -
#pragma mark JSON Generator Method
+ (NSData *)dataFromJSONObject:(id)object;
+ (NSString *)stringFromObject:(id)object;

+ (BOOL)isValidJSONObject:(id)object;

@end
