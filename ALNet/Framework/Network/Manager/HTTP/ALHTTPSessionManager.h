//
//  ALHTTPSessionManager.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 19..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALSerialization.h"
#import "ALSessionManager.h"
#import "ALHTTPSessionManagerProtocol.h"

@interface ALHTTPSessionManager : ALSessionManager <ALHTTPSessionManagerProtocol>
{
    __weak id _target;
    SEL _selector;
}

@property (strong, nonatomic) id requestInfo;   // 송신, 수신에 대한 정보
@property (strong, nonatomic) ALSerialization *serialization;

@end
