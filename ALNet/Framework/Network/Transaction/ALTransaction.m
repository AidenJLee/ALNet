//
//  ALTransaction.m
//  AIDENJLEENetworking
//
//  Created by HoJun Lee on 2013. 11. 12..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALTransaction.h"

@implementation ALTransaction


#pragma mark -
#pragma mark Init
- (id)initWithTarget:(id)target successSelector:(SEL)selSuccess failureSelector:(SEL)selFailure
{
    
    self = [super init];
    if (self) {
        
        _target     = target;
        _successSel = selSuccess;
        _failureSel = selFailure;
        
        _observerKeys = [[NSMutableArray alloc] initWithCapacity:5];
        
        _networkManager = [ALNetManager sharedInstance];
        
    }
    return self;
    
}

- (void)dealloc
{
    
    for (NSString *identifier in _observerKeys) {
        [self removeNotificationObserverForIdentifire:identifier];
    }
    [_observerKeys removeAllObjects];
    
}


#pragma mark -
#pragma mark Public Method
- (void)sendRequestForUserInfo:(id)userInfo
{
    
    if (!userInfo[@"url"]) {
        return;
    }
    
    [self addNotificationObserver];
    
    NSString *strDicPath = [[NSBundle mainBundle] pathForResource:@"RequestInfo" ofType:@"plist"];
    NSMutableDictionary *requestInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:strDicPath];
    NSLog(@"requestInfo : %@", requestInfo);
    
    requestInfo[@"url"]         = userInfo[@"url"];
    requestInfo[@"type"]        = userInfo[@"type"] ? [userInfo[@"type"] uppercaseString] : requestInfo[@"type"];
    requestInfo[@"task"]        = userInfo[@"task"] ? [userInfo[@"task"] uppercaseString] : requestInfo[@"task"];
    requestInfo[@"httpMethod"]  = userInfo[@"httpMethod"] ? [userInfo[@"httpMethod"] uppercaseString] : requestInfo[@"httpMethod"];
    
    requestInfo[@"fileURL"]     = userInfo[@"fileURL"] ? userInfo[@"fileURL"] : nil;
    requestInfo[@"bodyData"]    = userInfo[@"bodyData"] ? userInfo[@"bodyData"] : nil;
    
    requestInfo[@"param"]       = userInfo[@"param"] ? userInfo[@"param"] : @{} ;
    requestInfo[@"customParam"] = userInfo[@"customParam"] ? userInfo[@"customParam"] : @{} ;
    
    // image타입이고 2번째 URL도 들어온 경우 (thumbnail url)
    if ([requestInfo[@"type"] isEqualToString:@"IMAGE"] && userInfo[@"url2"]) {
        requestInfo[@"url2"] = userInfo[@"url2"];
    }
    
    // 전송 방식이 Uplode일 때 fileURL이나 bodyData 둘중 하나는 있어야 한다.
    if ([requestInfo[@"task"] isEqualToString:@"UPLOAD"]) {
     
        requestInfo[@"type"] = @"POST";
        if (!userInfo[@"bodyData"] && !userInfo[@"fileURL"]) {
            return;
        }
        
    }
    
    requestInfo[@"notiIdentifier"] = _observerKeys.lastObject;
    
#ifdef DEBUG
    NSLog(@"----- SEND START -----");
    NSLog(@"----------------------");
    
    NSLog(@"%@", requestInfo);
    
    NSLog(@"-----------------------");
    NSLog(@"-----  SEND END  -----\n");
#endif
    
    if (!_networkManager) {
        _networkManager = [ALNetManager sharedInstance];
    }
    
    [_networkManager requestWithRequestInfo:requestInfo];
    
}

// Callback By ALNetManager
- (void)didFinishReceive:(NSNotification *)finishNoti
{
    
    [self removeNotificationObserverForIdentifire:finishNoti.object[@"notiIdentifier"]];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if (finishNoti.object[@"result"]) {
        [_target performSelector:_successSel withObject:finishNoti.object];
    } else {
        [_target performSelector:_failureSel withObject:finishNoti.object];
    }
    
#pragma clang diagnostic pop
    
}


#pragma mark -
#pragma mark Public Method (for Framework)

- (void)addNotificationObserver
{
    NSString *strUniqueKey = [self uniqueKey];
    
    [_observerKeys addObject:strUniqueKey];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishReceive:)
                                                 name:strUniqueKey
                                               object:nil];
}

- (void)removeNotificationObserverForIdentifire:(NSString *)identifier
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:identifier object:nil];
}


#pragma mark -
#pragma mark UniqueKey Create Method Implement

- (NSString *)uniqueKey
{
    return [[self uuid] stringByAppendingString:[NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]]];
}

- (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)uuidStringRef;
}

@end
