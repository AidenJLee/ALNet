//
//  Standardinformation.m
//  PetsDiary
//
//  Created by HoJun Lee on 2013. 11. 19..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "Standardinformation.h"
#import "ALStringConvertor.h"

@implementation Standardinformation


#pragma mark -
#pragma mark Singleton Creation & Destruction Method Implement

static Standardinformation *__instance = nil;
+ (Standardinformation *)sharedInstance
{
    
    if (!__instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __instance = [[Standardinformation alloc] init];
            
            // User default에서 읽어봐서 값이 있으면 덮어쓰기
            NSUserDefaults *standardInfodefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *infoObject = [standardInfodefaults objectForKey:@"standardInformation"];
            
            if (infoObject) {
                __instance.apis = infoObject[@"apis"] ? infoObject[@"apis"] : nil;
                __instance.currentVersion   = infoObject[@"currentVersion"]   ? infoObject[@"currentVersion"] : nil;
                __instance.lastForceVersion = infoObject[@"lastForceVersion"] ? infoObject[@"lastForceVersion"] : nil;
                __instance.lastUpdateDate   = infoObject[@"lastUpdateDate"]   ? infoObject[@"lastUpdateDate"] : nil;
            }
            
        });
    }
    return __instance;
    
}

+ (void)releaseSharedInstance
{
    
    @synchronized(self)
    {
        __instance = nil;
    }
    
}


#pragma mark -
#pragma mark Init

- (id)init
{
    self = [super init];
    if (self) {
        
        _alt = [[ALTransaction alloc] initWithTarget:self
                                    successSelector:@selector(recieveSuccess:)
                                    failureSelector:@selector(recieveFailure:)];
        
    }
    return self;
}


#pragma mark -
#pragma mark Public Method
- (void)sendStandardInfomationRequest
{

    [_alt sendRequestForUserInfo:@{ @"url": self.URLString }];

}

- (void)standardInfomationInitialize:(information_receive_completion_handler)complateBlock
{
    
}

- (void)standardInformationUpdate:(information_receive_completion_handler)complateBlock
{
    
}


#pragma mark -
#pragma mark HTTPTransactionMethod
- (void)recieveSuccess:(id)result
{
    
    id apiResult = result[@"apis"];
    if (apiResult) {
        self.apis = apiResult;
        NSLog(@" Convert APIS : %@", self.apis);
    }
    if ([result[@"customParam"][@"method"] isEqualToString:@"init"]) {
        
        if (_initReceiveComplateBlock) {
            
            _initReceiveComplateBlock(YES, result);
            _initReceiveComplateBlock = NULL;
            
        }
        
    } else {
        
        if (_complateBlcok) {
            
            _complateBlcok(YES, result);
            _complateBlcok = NULL;
            
        }
        
    }
    
}

- (void)recieveFailure:(id)result
{
    
    if ([result[@"customParam"][@"method"] isEqualToString:@"init"]) {
        
        if (_initReceiveComplateBlock) {
            
            _initReceiveComplateBlock(YES, result);
            _initReceiveComplateBlock = NULL;
            
        }
        
    } else {
        
        if (_complateBlcok) {
            
            _complateBlcok(YES, result);
            _complateBlcok = NULL;
            
        }
        
    }
    
}


- (BOOL)isTimeChangesAfterAddingCertainNumber:(NSInteger)minute
{
    
    BOOL isNeedRequest = NO;
    
    if (!self.lastUpdateDate) {
        return YES;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSDate *dateLastUpdate = [dateFormatter dateFromString:self.lastUpdateDate];
    NSDate *dateToday      = [NSDate date];
    
    NSDateComponents *dateConversion = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit
                                                                       fromDate:dateLastUpdate
                                                                         toDate:dateToday
                                                                        options:0];
    
    if ([dateConversion minute] > minute) {
        isNeedRequest = YES;
    }
    
    return isNeedRequest;
    
}


@end
