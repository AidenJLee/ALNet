//
//  ALTransaction.h
//  AIDENJLEENetworking
//
//  Created by HoJun Lee on 2013. 11. 12..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALNetManager.h"
#import "ALNetManagerProtocol.h"
#import "ALTransactionProtocol.h"

@interface ALTransaction : NSObject <ALTransactionProtocol>
{
    id <ALNetManagerProtocol> __weak _networkManager;
    
    NSMutableArray *_observerKeys;  // 옵져버 이름들
    
    id _target;         // 콜백대상
    SEL _successSeleltor;    // 정상시 콜백
    SEL _failureSeleltor;    // 비정상시 콜백
}

- (void)didFinishReceive:(NSNotification *)noti; // Callback By ALNetManager

#pragma mark -
#pragma mark Public Method (for Framework)
- (void)addNotificationObserver;
- (void)removeNotificationObserverForIdentifire:(NSString *)identifier;

@end
