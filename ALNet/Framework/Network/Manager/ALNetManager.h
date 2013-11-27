//
//  ALNetManager.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALNetManagerProtocol.h"

@interface ALNetManager : NSObject <ALNetManagerProtocol>

// ALSession에서 사용하는 OperationQueue
@property (atomic, strong) NSOperationQueue *operationQueue;

+ (ALNetManager *)sharedInstance;
+ (void)releaseSharedInstance;

@end
