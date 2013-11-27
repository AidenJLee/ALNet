//
//  ALNetConst.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 21..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALNetConst.h"


#pragma mark -
#pragma mark Value Result Naming


NSString * const ERROR_TITLE  = @"Error";
NSString * const RESULT_TITLE = @"Results";

NSString * const ALTRANSACTION_IDENTIFIER = @"TransactionIdentifier";


#pragma mark -
#pragma mark - Session Configuration

NSString * const OPERATIONQUEUE_NAME    = @"com.entist.ALNet.operationQueue";
NSString * const SESSION_DOWNLOAD_ID    = @"com.entist.ALNet.downloadSession";


#pragma mark -
#pragma mark Task Observing KeyPath

NSString * const OBSERVE_STATE = @"state";


#pragma mark -
#pragma mark - Notifications

NSString * const DOWNLOAD_SUCCESS_NOTI = @"DownloadTaskDidSuccessNotification";
NSString * const FILESAVE_FAILURE_NOTI = @"DownloadedFileSaveFailNotification";

NSString * const TASK_DID_START_NOTI   = @"TaskDidStartNotification";
NSString * const TASK_DID_SUSPEND_NOTI = @"TaskDidSuspendNotification";
NSString * const TASK_DID_FINISH_NOTI  = @"TaskDidFinishNotification";


#pragma mark -
#pragma mark ALNetError Description

NSString * const NETWORKING_ERROR_DOMAIN = @"NetworkinghasError";