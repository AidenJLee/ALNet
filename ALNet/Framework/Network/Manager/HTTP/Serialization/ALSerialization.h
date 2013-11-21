//
//  ALSerialization.h
//  AIDENJLEENetworking
//
//  Created by HoJun Lee on 2013. 11. 12..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALSerialization : NSObject

@property (nonatomic, strong) NSIndexSet *statusCodes;
@property (nonatomic, strong) NSSet *contentTypes;

- (id)objectForResponse:(NSURLResponse *)response data:(NSData *)data;


#pragma mark -
#pragma mark JSON Parsing Method
+ (id)objectFromJSONData:(NSData *)data;
+ (id)objectFromJSONString:(NSString *)JSONString;


#pragma mark -
#pragma mark JSON Generator Method
+ (NSData *)JSONDataFromJSONObject:(id)object;
+ (NSString *)JSONStringFromObject:(id)object;

+ (BOOL)isValidJSONObject:(id)object;

@end
