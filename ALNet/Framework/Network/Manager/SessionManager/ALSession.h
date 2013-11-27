//
//  ALSession.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 27..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALSessionProtocol.h"
#import "ALNetManager.h"

@interface ALSession : NSObject <ALSessionProtocol, NSURLSessionDelegate>
{
    __weak id _target;
    SEL _selector;
}

// ALSession
@property (nonatomic, strong) id requestInfo;   // 송신, 수신에 대한 정보
@property (nonatomic, strong, readonly) NSURLSession *session;

// NSKeyValueObserving For Task Method Implement
- (void)addObserverForTask:(id)task;

@end
