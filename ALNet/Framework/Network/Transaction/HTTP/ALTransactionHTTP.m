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
    
    NSString *strURL = userInfo[@"url"];
    if (!strURL) {
        return;
    }
    
    [self addNotificationObserver];
    NSMutableDictionary *requestInfo = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    requestInfo[@"url"]         = strURL;
    requestInfo[@"task"]        = userInfo[@"task"] ? [userInfo[@"task"] uppercaseString] : @"DATA";
    requestInfo[@"httpMethod"]  = userInfo[@"httpMethod"] ? [userInfo[@"httpMethod"] uppercaseString] : @"GET";
    requestInfo[@"type"]        = userInfo[@"type"] ? [userInfo[@"type"] uppercaseString] : @"JSON";
    
    requestInfo[@"param"]       = userInfo[@"param"] ? userInfo[@"param"] : @{} ;
    requestInfo[@"customParam"] = userInfo[@"customParam"] ? userInfo[@"customParam"] : @{} ;
    
    
    // image타입이고 2번째 URL도 들어온 경우 (thumbnail url)
    if ([requestInfo[@"type"] isEqualToString:@"IMAGE"] && userInfo[@"url2"]) {
        requestInfo[@"url2"] = userInfo[@"url2"];
    }
    
    
    // 전송 방식이 Uplode일 때 fileURL이나 bodyData 둘중 하나는 있어야 한다.
    if ([requestInfo[@"task"] isEqualToString:@"UPLOAD"]) {
        
        requestInfo[@"httpMethod"] = @"POST";
        
        // bodyData가 있냐?
        if (userInfo[@"bodyData"]) {
            requestInfo[@"bodyData"] = userInfo[@"bodyData"];
        } else {
            // fileURL이 있냐?
            if (userInfo[@"fileURL"]) {
                requestInfo[@"fileURL"] = userInfo[@"fileURL"];
            } else { // 둘다 없으면 안행~
                return;
            }
        }
        
    }
    
    // 완료 된 오브젝트를 받을 노티피케이션 아이디 넣기
    requestInfo[@"notiIdentifier"] = _observerKeys.lastObject;
    
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
    
    [self removeNotificationObserverForIdentifire:noti.object[@"notiIdentifier"]];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if (noti.object[@"value"]) {
        [_target performSelector:_successSel withObject:noti.object];
    } else {
        [_target performSelector:_failureSel withObject:noti.object];
    }
    
#pragma clang diagnostic pop
    
}

@end
