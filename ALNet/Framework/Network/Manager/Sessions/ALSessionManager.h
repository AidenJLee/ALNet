//
//  ALSessionManager.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALNetConst.h"

@interface ALSessionManager : NSObject <NSURLSessionDelegate>
{
    __weak id _target;
    SEL _selector;
}


#pragma mark -
#pragma mark - ALSessionManager
@property (nonatomic, strong) id requestInfo;   // 송신, 수신에 대한 정보
@property (nonatomic, strong, readonly) NSURLSession *session;

// ALSessionManager + TaskDelegate
@property (copy, nonatomic) NSURL *downloadedFileURL;
//@property (strong, nonatomic) NSMutableData *mutableData;
@property (strong, nonatomic) NSProgress *uploadProgress;
@property (strong, nonatomic) NSProgress *downloadProgress;


// Init
- (id)initWithConfig:(NSURLSessionConfiguration *)configuration
              Target:(id)target
            selector:(SEL)selector
         requestInfo:(NSDictionary *)requestInfo;

// Public Method
- (void)invalidateSessionCancel;
- (void)invalidateAndFinishTasksCancel;

// Upload Task
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromFile:(NSURL *)fileURL
                                completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromData:(NSData *)bodyData
                                completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

// Download Task
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                    completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;
- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                       completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;



@end
