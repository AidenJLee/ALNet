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
        _serialization = [[ALSerialization alloc] init];
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
    if (!self.requestInfo) {
        return;
    }
    
    NSMutableURLRequest *request = [self.serialization requestWithMethod:requestInfo[@"httpMethod"] URL:requestInfo[@"url"] parameters:requestInfo[@"param"]];
    
    NSString *strTask = requestInfo[@"task"];
    if ([strTask isEqualToString:@"DATA"]) {
        [self DataTaskWithRequest:request];
    } else if ([strTask isEqualToString:@"UPLOAD"]) {
        
    } else if ([strTask isEqualToString:@"DOWNLOAD"]) {
        
    } else {
        
    }
    
}

- (void)DataTaskWithRequest:(NSURLRequest *)request
{
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        id resultObject = [self.serialization objectForResponse:response data:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_target performSelectorOnMainThread:_selector withObject:resultObject waitUntilDone:NO];
        });
    }];
    [self addObserverForTask:task];
    [task resume];
}

- (void)UploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData
{
    
    __block NSURLSessionUploadTask *task = [self.session uploadTaskWithRequest:request fromData:bodyData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        id resultObject = [self.serialization objectForResponse:response data:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_target performSelectorOnMainThread:_selector withObject:resultObject waitUntilDone:NO];
        });
    }];
    [self addObserverForTask:task];
    [task resume];
    
}

- (void)UploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL
{
    __block NSURLSessionUploadTask *task = [self.session uploadTaskWithRequest:request fromFile:fileURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        id resultObject = [self.serialization objectForResponse:response data:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_target performSelectorOnMainThread:_selector withObject:resultObject waitUntilDone:NO];
        });
    }];
    [self addObserverForTask:task];
    [task resume];
}

- (void)DownloadTaskWithRequest:(NSURLRequest *)request
{
    
}

- (void)DownloadTaskWithResumeData:(NSData *)resumeData
{
    
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
