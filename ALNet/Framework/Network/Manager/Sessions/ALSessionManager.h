//
//  ALSessionManager.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^ALProgressBlock)(double totalBytesWritten, double bytesExpected);
typedef void (^ALCompletionBlock)(NSURL *imageUrl, BOOL success);

@interface ALSessionManager : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate>


#pragma mark -
#pragma mark - ALSessionManager
@property (readonly, strong, nonatomic) NSURLSession *session;

// Init
- (instancetype)initWithConfig:(NSURLSessionConfiguration *)configuration;

// Public Method
- (void)invalidateSessionCancel;
- (void)invalidateAndFinishTasksCancel;

- (NSArray *)getTasksWithTaskType:(NSString *)taskType;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
#pragma mark -
#pragma mark - ALSessionManager + TaskDelegate
@property (strong, nonatomic) NSMutableData *mutableData;
@property (strong, nonatomic) NSProgress *uploadProgress;
@property (strong, nonatomic) NSProgress *downloadProgress;
@property (copy, nonatomic) NSURL *downloadedFileURL;


@end
