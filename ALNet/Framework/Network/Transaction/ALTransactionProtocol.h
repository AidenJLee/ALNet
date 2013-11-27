//
//  ALTransactionProtocol.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 22..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ALTransactionProtocol <NSObject>

/*! 초기화
 * \param target 요청에 대한 응답을 처리할 대상
 * \param sel 요청 성공시 해야 할 액션
 * \param failSel 요청 실패시 해야 할 액션
 * \return ALTransaction Instance Object
 */
- (id)initWithTarget:(id)target successSelector:(SEL)selSuccess failureSelector:(SEL)selFailure;

/*! 원격지에 요청을 보낸다.
 * \param userInfo common, param, customParam으로 이루어진 Dictionary
 */
- (void)sendRequestForUserInfo:(id)userInfo;

@end
