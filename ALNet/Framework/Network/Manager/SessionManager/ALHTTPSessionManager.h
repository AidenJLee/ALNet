//
//  ALHTTPSessionManager.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 19..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALSessionManager.h"

@interface ALHTTPSessionManager : ALSessionManager

//ALNet에서 사용
- (void)sendHTTPWithRequestInfo:(id)requestInfo;

@end
