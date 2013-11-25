//
//  ALSessionManager.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALNetConst.h"
#import "ALSessionManagerProtocol.h"

@interface ALSessionManager : NSObject <NSURLSessionDelegate, ALSessionManagerProtocol>
{
    __weak id _target;
    SEL _selector;
}

// ALSessionManager
@property (readonly, strong, nonatomic) NSURLSession *session;
@property (nonatomic, strong) id requestInfo;   // 송신, 수신에 대한 정보

// ALSessionManager + TaskDelegate ()
@property (copy, nonatomic) NSURL *downloadedFileURL;

// Add NSKeyValueObserving For Task Method Implement
- (void)addObserverForTask:(id)task;

@end
