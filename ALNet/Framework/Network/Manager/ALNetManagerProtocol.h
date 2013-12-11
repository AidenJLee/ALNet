//
//  ALNetManagerProtocol.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ALNetManagerProtocol <NSObject>

@required
/*! Transaction으로 부터 requsetInfo를 받아 작업을 분류하여 작업 오브젝트에 요청한다.
 *  \param requsetInfo 요청에 필요한 정보
 */
- (void)requestWithRequestInfo:(NSDictionary *)requestInfo;

@end
