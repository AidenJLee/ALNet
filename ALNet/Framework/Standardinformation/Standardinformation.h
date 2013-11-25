//
//  Standardinformation.h
//  PetsDiary
//
//  Created by HoJun Lee on 2013. 11. 19..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALTransaction.h"

typedef void (^information_receive_completion_handler)(BOOL success, id result);

@interface Standardinformation : NSObject
{
    ALTransaction *_alt;
    information_receive_completion_handler _initReceiveComplateBlock;
    information_receive_completion_handler _complateBlcok;
}

@property (nonatomic, copy) NSString *URLString;

@property (nonatomic, strong) id apis;
@property (nonatomic, strong) NSString *currentVersion;
@property (nonatomic, strong) NSString *lastForceVersion;
@property (nonatomic, strong) NSString *lastUpdateDate;

#pragma mark -
#pragma mark Singleton Creation & Destruction Method

+ (Standardinformation *)sharedInstance;
+ (void)releaseSharedInstance;


- (void)sendStandardInfomationRequest;
- (void)standardInfomationInitialize:(information_receive_completion_handler)complateBlock;
- (void)standardInformationUpdate:(information_receive_completion_handler)complateBlock;

@end
