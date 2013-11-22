//
//  ALNetConst.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 21..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_OPERATIONQUEUE_COUNT 5

#pragma mark -
#pragma mark Session Configuration

extern NSString * const SESSION_DOWNLOAD_ID;
extern NSString * const OPERATION_QUEUE_NAME;
extern NSString * const OPERATION_QUEUE_STATUS;



#pragma mark -
#pragma mark Task Observing KeyPath

extern NSString * const TASK_STATE_OBSERVING;

#pragma mark -
#pragma mark Notifications Identification

extern NSString * const TASK_DID_START_NOTI;
extern NSString * const TASK_DID_FINISH_NOTI;
extern NSString * const TASK_DID_SUSPEND_NOTI;

extern NSString * const DOWNLOAD_SUCCESS_NOTI;
extern NSString * const FILESAVE_FAILURE_NOTI;


#pragma mark -
#pragma mark ALNetError Description

extern NSString * const NETWORKING_ERROR_DOMAIN;

/**에러코드 정의*/
typedef enum ALNetErrorCode : NSInteger
{
    kECodeDBError             = 0,    ///< 디비 에러
    kECodeMissingParameter    = 1,    ///< 파라메터 부족
    kECodeNetworkError        = 2,    ///< 네트워크 에러
    kECodeFacebookError       = 3,    ///< 페이스북 통신에러
    kECodeExistUsername       = 4,    ///< 이미 존재하는 유저네임
    kECodeExistMail           = 5,    ///< 이미 존재하는 메일주소
    kECodeNotSavedUser        = 6,    ///< 유저정보 불일치
    kECodeEmailFormatError    = 7,    ///< 이메일 포맷 불일치
    kECodePasswordInvalid     = 8     ///< 패스워드 불일치
} ALNetErrorCode;
