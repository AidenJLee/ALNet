//
//  ALStringConvertor.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 22..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALStringConvertor.h"

// String Convertor - StrinfWithFormat
#define SC(...) [NSString stringWithFormat:__VA_ARGS__]


/*
 Example -
 
 NSLog(@" %@", [ALStringConvertor convertObject:apiDic firstString:@"im" secondString:@"aidenjlee"]);
 */
@implementation ALStringConvertor

+ (void)example
{
    NSDictionary *apiArgc1 = @{
                                    @"restful": @"/v1/users/%@",
                                    @"search": @"/v1/users/%@/search",
                                    @"follower": @"/v1/users/%@/follower",
                                    @"following": @"/v1/users/%@/following"
                                    };
    
    NSDictionary *apiArgc2 = @{
                                @"user_find": @"/v1/users/find/%@/%@"
                             };
    
    NSDictionary *convertedApiArgc1 = [self.class convertObject:apiArgc1 argcOne:@"aidenjlee"];
    NSDictionary *convertedApiArgc2 = [self.class convertObject:apiArgc2 argcOne:@"i`m" argcTwo:@"aidenjlee"];
    NSLog(@"Original : %@", apiArgc1);
    NSLog(@"Converted : %@", convertedApiArgc1);
    NSLog(@"Original : %@", apiArgc2);
    NSLog(@"Original : %@", convertedApiArgc2);
}

+ (id)convertObject:(id)original argcOne:(NSString *)one
{
 
    if ([original isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *convertedInfo = [[NSMutableDictionary alloc] initWithCapacity:10];
        [original enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [convertedInfo setObject:[NSString stringWithFormat:obj, one] forKey:key];
        }];
        return convertedInfo;
        
    } else if ([original isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *convertedInfo = [[NSMutableArray alloc] initWithCapacity:10];
        [original enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [convertedInfo addObject:[NSString stringWithFormat:obj, one]];
        }];
        return convertedInfo;
        
    }
    return nil;
    
}

+ (id)convertObject:(id)original
            argcOne:(NSString *)one
            argcTwo:(NSString *)two
{
    
    if ([original isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *convertedInfo = [[NSMutableDictionary alloc] initWithCapacity:10];
        [original enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [convertedInfo setObject:[NSString stringWithFormat:obj, one, two] forKey:key];
        }];
        return convertedInfo;
        
    } else if ([original isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *convertedInfo = [[NSMutableArray alloc] initWithCapacity:10];
        [original enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [convertedInfo addObject:[NSString stringWithFormat:obj, one, two]];
        }];
        return convertedInfo;
        
    }
    return nil;
    
}

+ (id)convertObject:(id)original
            argcOne:(NSString *)one
            argcTwo:(NSString *)two
          argcThree:(NSString *)three
{
    
    if ([original isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *convertedInfo = [[NSMutableDictionary alloc] initWithCapacity:10];
        [original enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [convertedInfo setObject:[NSString stringWithFormat:obj, one, two, three] forKey:key];
        }];
        return convertedInfo;
        
    } else if ([original isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *convertedInfo = [[NSMutableArray alloc] initWithCapacity:10];
        [original enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [convertedInfo addObject:[NSString stringWithFormat:obj, one, two, three]];
        }];
        return convertedInfo;
        
    }
    return nil;
    
}

@end
