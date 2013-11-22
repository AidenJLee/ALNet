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
/*! Transaction으로 부터 requsetInfo를 받아 작업을 분류하여 서버에 요청한다.
 *  \param requsetInfo 요청에 필요한 정보
 *  \return network manager가 정상적으로 요청을 받았는지 여부 (BOOL type)
 */
- (void)requestWithRequestInfo:(NSDictionary *)requestInfo;

@end
