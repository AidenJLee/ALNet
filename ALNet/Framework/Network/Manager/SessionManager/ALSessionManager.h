//
//  ALSessionManager.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALNetConst.h"
#import "ALSerialization.h"
#import "ALSessionManagerProtocol.h"

@interface ALSessionManager : NSObject <NSURLSessionDelegate, ALSessionManagerProtocol>
{
    __weak id _target;
    SEL _selector;
}

// ALSessionManager
@property (nonatomic, strong, readonly) NSURLSession *session;
@property (nonatomic, strong) id requestInfo;   // 송신, 수신에 대한 정보
@property (nonatomic, strong) ALSerialization *serialization;

// ALSessionManager + TaskDelegate ()
@property (nonatomic, copy) NSURL *downloadedFileURL;
@property (nonatomic, strong) NSMutableData *mutableData;

// Add NSKeyValueObserving For Task Method Implement
- (void)addObserverForTask:(id)task;

@end
