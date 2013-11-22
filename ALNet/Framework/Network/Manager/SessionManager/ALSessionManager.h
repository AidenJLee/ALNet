//
//  ALSessionManager.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALNetConst.h"
#import "ALSessionManagerProtocol.h"

@interface ALSessionManager : NSObject <NSURLSessionDelegate, ALSessionManagerProtocol>
{
    __weak id _target;
    SEL _selector;
}

// ALSessionManager
@property (readonly, strong, nonatomic) NSURLSession *session;

// ALSessionManager + TaskDelegate ()
@property (copy, nonatomic) NSURL *downloadedFileURL;
@property (strong, nonatomic) NSProgress *uploadProgress;
@property (strong, nonatomic) NSProgress *downloadProgress;
//@property (strong, nonatomic) NSMutableData *mutableData;


// Data Task Observing
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

// Upload Task Observing
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromFile:(NSURL *)fileURL
                                completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromData:(NSData *)bodyData
                                completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

// Download Task Observing
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                    completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;
- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                       completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;



@end
