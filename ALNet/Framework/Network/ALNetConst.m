//
//  ALNetConst.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 21..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALNetConst.h"


#pragma mark -
#pragma mark - Session Configuration

NSString * const SESSION_DOWNLOAD_ID  = @"com.entist.ALNet.downloadSession";
NSString * const OPERATION_QUEUE_NAME = @"com.entist.ALNet.operationQueue";
NSString * const OPERATION_QUEUE_STATUS = @"DelegateQueueOperationCount";


#pragma mark -
#pragma mark - Notifications

NSString * const DOWNLOAD_SUCCESS_NOTI = @"DownloadTaskDidSuccessNotification";
NSString * const FILESAVE_FAILURE_NOTI = @"DownloadedFileSaveFailNotification";

NSString * const TASK_DID_START_NOTI   = @"";
NSString * const TASK_DID_FINISH_NOTI  = @"";
NSString * const TASK_DID_SUSPEND_NOTI = @"";

z