//
//  ALSessionManagerProtocol.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 22..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ALSessionManagerProtocol <NSObject>

@required
/*! Session을 생성하고 요청에 대한 결과를 반환할 Target과 seletor 정보를 가지고 있는다
 *  \param target 요청에 대한 응답을 처리할 대상
 *  \param selector 요청에 대한 응답을 해야 할 액션
 *  \param configuration Session을 생성 환경설정 파일
 *  \return instancetype SessionManager의 인스턴스
 */
- (instancetype)initWithTarget:(id)target
                      selector:(SEL)selector
                 configuration:(NSURLSessionConfiguration *)configuration;

/*! 처리 되지 않은 모든 Tasks까지 취소한다.
 *  task cancellation은 task의 상태값을 받아야 하는데 간혹 어떤 tasks는 이미 완료되어도 cancel 명령을 받을 수 있다.
 */
- (void)invalidateSessionCancel;

/*! 완료 된 작업은 즉시 취소 하지만 실행중인 기존 작업이 완료 될 때 까지는 실행이 허용된다.
 *  Session은 URLSession:didBecomeInvalidWithError: 이 호출 될 때까지 delegate callbacks을 유지하고 있을 것이다.
 *  대신 새 작업은 만들 수 없다.
 */
- (void)invalidateAndFinishTasksCancel;

@end
