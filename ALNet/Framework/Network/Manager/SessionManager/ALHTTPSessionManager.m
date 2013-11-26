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
    
    if (!requestInfo) {
        return;
    }
    self.requestInfo = requestInfo;
    
    NSMutableURLRequest *request = [self.serialization requestWithMethod:requestInfo[@"httpMethod"] URL:requestInfo[@"url"] parameters:requestInfo[@"param"]];
    
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
        self.requestInfo[RESULT_TITLE] = [self.serialization objectForResponse:response data:data];
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
        self.requestInfo[RESULT_TITLE] = [self.serialization objectForResponse:response data:data];
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
        self.requestInfo[RESULT_TITLE] = [self.serialization objectForResponse:response data:data];
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
        self.requestInfo[RESULT_TITLE] = @{ @"location": location, @"response": response };
        dispatch_async(dispatch_get_main_queue(), ^{
            [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
        });
    }];
    [self addObserverForTask:task];
    [task resume];
}


// ALHTTPSession Standardalone Method
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler
{
    
    NSURL *URL = [NSURL URLWithString:URLString];
    if (!URL) {
        return;
    }
    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"GET" URL:URL parameters:parameters];
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Function : %s  Source Line : %d" , __FUNCTION__, __LINE__);
        }
        if (completionHandler) {
            NSError *error = nil;
            id result = [self.serialization objectForResponse:response data:data];
            if (error) {
                NSLog(@"Serialization Error : %@", [error description]);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(result);
            });
        }
    }];
    [self addObserverForTask:task];
    [task resume];
    
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler
{
    
    NSURL *URL = [NSURL URLWithString:URLString];
    if (!URL) {
        return;
    }
    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"POST" URL:URL parameters:parameters];
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler([self.serialization objectForResponse:response data:data]);
            });
        }
    }];
    [self addObserverForTask:task];
    [task resume];
    
}

- (void)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler
{
    
    NSURL *URL = [NSURL URLWithString:URLString];
    if (!URL) {
        return;
    }
    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"PTU" URL:URL parameters:parameters];
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler([self.serialization objectForResponse:response data:data]);
            });
        }
    }];
    [self addObserverForTask:task];
    [task resume];
    
}


- (void)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler
{
    
    NSURL *URL = [NSURL URLWithString:URLString];
    if (!URL) {
        return;
    }
    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"DELETE" URL:URL parameters:parameters];
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler([self.serialization objectForResponse:response data:data]);
            });
        }
    }];
    [self addObserverForTask:task];
    [task resume];
    
}

@end
