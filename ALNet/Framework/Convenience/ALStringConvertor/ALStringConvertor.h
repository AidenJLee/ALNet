//
//  ALStringConvertor.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 22..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALStringConvertor : NSObject

+ (void)example;

+ (id)convertObject:(id)original argcOne:(NSString *)one;
+ (id)convertObject:(id)original argcOne:(NSString *)one argcTwo:(NSString *)two;
+ (id)convertObject:(id)original argcOne:(NSString *)one argcTwo:(NSString *)two argcThree:(NSString *)three;

@end
