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
@property (nonatomic, strong) NSString *bundleVersion;
@property (nonatomic, strong) NSString *currentVersion;
@property (nonatomic, strong) NSString *lastForceVersion;
@property (nonatomic, strong) NSString *lastUpdateDate;

#pragma mark -
#pragma mark Singleton Creation & Destruction Method

+ (Standardinformation *)sharedInstance;
+ (void)releaseSharedInstance;

// Request 날리는 메소드
- (void)sendStandardInfomationRequest;

// 기준정보를 초기화 하거나 업데이트 하는 메소드
- (void)standardInfomationInitialize:(information_receive_completion_handler)complateBlock;
- (void)standardInformationUpdate:(information_receive_completion_handler)complateBlock;

// 마지막 업데이트로 부터 얼마나 지났는지 계산해 주는 메소드
- (BOOL)isTimeChangesAfterAddingCertainNumber:(NSInteger)minute;

@end
