//
//  ALHTTPSession.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 28..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALSession.h"
#import "ALSerialization.h"

@interface ALHTTPSession : ALSession

@property (nonatomic, strong) ALSerialization *serialization;

//ALNet에서 사용
- (void)sendHTTPWithRequestInfo:(id)requestInfo;

@end
