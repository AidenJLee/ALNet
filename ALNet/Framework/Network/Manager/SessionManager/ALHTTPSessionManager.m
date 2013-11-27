//
//  ALHTTPSessionManager.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 19..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALHTTPSessionManager.h"

@implementation ALHTTPSessionManager


#pragma mark -
#pragma mark Initialization
- (instancetype)initWithTarget:(id)target
                      selector:(SEL)selector
                 configuration:(NSURLSessionConfiguration *)configuration
{
    
    self = [super initWithTarget:target selector:selector configuration:configuration];
    if (self) {
        
	}
	return self;
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ Description: %p, session: %@, operationQueue: %@", NSStringFromClass([self class]), self, self.session, self.session.delegateQueue];
}


#pragma mark -
#pragma mark - HTTP Public Method Implement
- (void)sendHTTPWithRequestInfo:(id)requestInfo
{
    
    self.requestInfo = requestInfo;
    
    NSMutableURLRequest *request = [self.serialization requestWithURL:requestInfo[@"url"] httpMethod:requestInfo[@"httpMethod"] parameters:requestInfo[@"param"]];
    
    NSString *strTask = requestInfo[@"task"];
    if ([strTask isEqualToString:@"DATA"]) {
        [self sendDataTaskWithRequest:request];
    } else if ([strTask isEqualToString:@"UPLOAD"]) {
        
        if (requestInfo[@"bodyData"]) {
            [self sendUploadTaskWithRequest:request fromData:requestInfo[@"bodyData"]];
        } else if (requestInfo[@"fileURL"]) {
            [self sendUploadTaskWithRequest:request fromFile:requestInfo[@"fileURL"]];
        } else {
            // TODO : Upload error
        }
        
    } else if ([strTask isEqualToString:@"DOWNLOAD"]) {
        [self sendDownloadTaskWithRequest:request];
    } else {
        NSLog(@"Function : %s  Source Line : %d" , __FUNCTION__, __LINE__);
    }
    
}

- (void)sendDataTaskWithRequest:(NSURLRequest *)request
{
    
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error : %@Function : %s  Source Line : %d" , [error description], __FUNCTION__, __LINE__);
        }
        // 데이터 확인 및 Serialization
        [self spliteReceiveDataForResponse:response data:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
        });
    }];
    [self addObserverForTask:task];
    [task resume];
    
}

- (void)sendUploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData
{
    
    __block NSURLSessionUploadTask *task = [self.session uploadTaskWithRequest:request fromData:bodyData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error : %@Function : %s  Source Line : %d" , [error description], __FUNCTION__, __LINE__);
        }
        // 데이터 확인 및 Serialization
        [self spliteReceiveDataForResponse:response data:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
        });
    }];
    [self addObserverForTask:task];
    [task resume];
    
}

- (void)sendUploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL
{
    
    __block NSURLSessionUploadTask *task = [self.session uploadTaskWithRequest:request fromFile:fileURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error : %@Function : %s  Source Line : %d" , [error description], __FUNCTION__, __LINE__);
        }
        [self spliteReceiveDataForResponse:response data:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
        });
    }];
    [self addObserverForTask:task];
    [task resume];
    
}

- (void)sendDownloadTaskWithRequest:(NSURLRequest *)request
{
    
    __block NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error : %@Function : %s  Source Line : %d" , [error description], __FUNCTION__, __LINE__);
        }
        // TODO : download에 대한 예외 처리 필요
        self.requestInfo[RESULT_TITLE] = @{ @"location": location, @"response": response };
        dispatch_async(dispatch_get_main_queue(), ^{
            [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
        });
    }];
    [self addObserverForTask:task];
    [task resume];
    
}

- (void)sendDownloadTaskWithResumeData:(NSData *)resumeData
{
    __block NSURLSessionDownloadTask *task = [self.session downloadTaskWithResumeData:resumeData completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error : %@Function : %s  Source Line : %d" , [error description], __FUNCTION__, __LINE__);
        }
        // TODO : download resume에 대한 예외 처리 필요
        self.requestInfo[RESULT_TITLE] = @{ @"location": location, @"response": response };
        dispatch_async(dispatch_get_main_queue(), ^{
            [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
        });
    }];
    [self addObserverForTask:task];
    [task resume];
}


#pragma mark -
#pragma mark - Receive confirm Method Implement
- (void)spliteReceiveDataForResponse:(NSURLResponse *)response data:(NSData *)data
{
    
    id result = [self.serialization objectForResponse:response data:data];
    if (!result[ERROR_TITLE]) {
        self.requestInfo[RESULT_TITLE] = result;
    } else {
        self.requestInfo[ERROR_TITLE] = result;
    }
    
}

@end
