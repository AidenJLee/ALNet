//
//  ALTransactionHTTP.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 22..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALTransactionHTTP.h"

@implementation ALTransactionHTTP

#pragma mark -
#pragma mark Init
- (id)initWithTarget:(id)target successSelector:(SEL)selSuccess failureSelector:(SEL)selFailure
{
    
    self = [super initWithTarget:target successSelector:selSuccess failureSelector:selFailure];
    if (self) {
        
        _networkManager = [ALNetManager sharedInstance];
        
    }
    return self;
    
}


- (void)sendRequestForUserInfo:(id)userInfo
{
    
    NSURL *URL = [NSURL URLWithString:userInfo[@"url"]];
    if (!URL) {
        NSDictionary *errorDic = @{ ERROR_TITLE:  @"URL error", @"description": @"URL Not found" };
        [self returnObject:errorDic];
        return;
    }
    
    // 정상으로 판단하고 Notification 센터에 옵저버를 등록한다
    [self addNotificationObserver];
    
    // userInfo를 기반으로 RequestInfo정보를 생성한다
    NSMutableDictionary *requestInfo = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    requestInfo[@"url"]         = URL;
    requestInfo[@"task"]        = userInfo[@"task"] ? [userInfo[@"task"] uppercaseString] : @"DATA";
    requestInfo[@"type"]        = userInfo[@"type"] ? [userInfo[@"type"] uppercaseString] : @"JSON";
    requestInfo[@"httpMethod"]  = userInfo[@"httpMethod"] ? [userInfo[@"httpMethod"] uppercaseString] : @"GET";
    
    
    NSDictionary *param = userInfo[@"param"];
    NSDictionary *customParam = userInfo[@"customParam"];
    
    if (param || [param isKindOfClass:[NSDictionary class]]) {
        requestInfo[@"param"] = param;
    } else {
        requestInfo[@"param"] = @{};    // @"Parameter가 없거나 Dictionary가 아닙니다"
    }
    
    
    // 전송 방식이 Uplode일 때 fileURL이나 bodyData 값이 있어야 한다.
    if ([requestInfo[@"task"] isEqualToString:@"UPLOAD"]) {
        
        requestInfo[@"httpMethod"] = @"multipart/form-data";
        
        // bodyData가 있냐?
        if ([param isEqual:@{}]) {
            
        } else {
            // fileURL이 있냐?
            if (userInfo[@"fileURL"]) {
                requestInfo[@"fileURL"] = userInfo[@"fileURL"];
            } else { // 둘다 없으면 안행~
                NSDictionary *errorDic = @{
                                           ERROR_TITLE: @{
                                                   @"error": @"Upload Task error",
                                                   @"description": @"bodyData or fileURL Not found"
                                                   }
                                           };
                [self returnObject:errorDic];
                return;
            }
        }
        
    }
    
    
    
    if (customParam || [customParam isKindOfClass:[NSDictionary class]]) {
        requestInfo[@"customParam"] = customParam;
    } else {
        requestInfo[@"customParam"] = @{};  // @"CustomParameter가 없거나 Dictionary가 아닙니다"
    }
    
    
    
    
    // 완료 된 오브젝트를 받을 노티피케이션 아이디 넣기
    requestInfo[ALTRANSACTION_IDENTIFIER] = _observerKeys.lastObject;
    
#ifdef DEBUG
    NSLog(@"----------------------");
    NSLog(@"----- SEND START -----");
    NSLog(@"----------------------");
    
    NSLog(@"%@", requestInfo);
    
    NSLog(@"----------------------");
    NSLog(@"-----  SEND END  -----");
    NSLog(@"----------------------\n");
#endif
    
    if (!_networkManager) {
        _networkManager = [ALNetManager sharedInstance];
    }
    
    [_networkManager requestWithRequestInfo:requestInfo];
    
}

// Callback By ALNetManager
- (void)didFinishReceive:(NSNotification *)noti
{
    
    [self removeNotificationObserverForIdentifire:noti.object[ALTRANSACTION_IDENTIFIER]];
    [self returnObject:noti.object];
    
}

- (void)returnObject:(id)object
{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if (object[ERROR_TITLE]) {
        [_target performSelector:_failureSeleltor withObject:object[ERROR_TITLE]];
    } else {
        [_target performSelector:_successSeleltor withObject:object[RESULT_TITLE]];
    }
    
#pragma clang diagnostic pop
    
}

@end
