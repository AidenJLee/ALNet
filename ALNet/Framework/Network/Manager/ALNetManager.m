//
//  ALNetManager.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALNetManager.h"
#import "UIAsyncImageView.h"

@implementation ALNetManager


#pragma mark -
#pragma mark Singleton Creation & Destruction Method Implement

static ALNetManager *__instance = nil;
+ (ALNetManager *)sharedInstance
{
    
    if (!__instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __instance = [[ALNetManager alloc] init];
        });
    }
    return __instance;
    
}

+ (void)releaseSharedInstance
{
    
    @synchronized(self)
    {
        __instance = nil;
    }
    
}


#pragma mark -
#pragma mark Initialization

- (instancetype)init
{
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
    
}


#pragma mark -
#pragma mark ALNetworkManagerProtocol Method Implement

- (void)requestWithRequestInfo:(id)requestInfo
{
    
    NSString *strURL = requestInfo[@"url2"];
    
    if (strURL == nil || [strURL isEqualToString:@""]) {
        strURL = requestInfo[@"url"];
    }
    
    if (strURL == nil || [strURL isEqualToString:@""]) {
        return;
    }
    
    // 상단 네트워크 인디케이터 켬
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    // Configuration Custom 가능 - ALConfiguration.h에서
    NSURLSessionConfiguration *config = [ALSessionConfiguration defaultConfiguration];
    
    NSString *strTask = requestInfo[@"task"];
    if ([strTask isEqualToString:@"DOWNLOAD"]) {
        config = [ALSessionConfiguration backgroundConfiguration];
    } else if ([strTask isEqualToString:@"UPLOAD"]) {
        // 딱히 설정 바꿔야 하는게 있다면.... 변경
        // 하지만 아마 없을꺼야...
    }
    
    
    if ([requestInfo[@"task"] isEqualToString:@"DOWNLOAD"]) {
        config = nil;
    }
    
    ALHTTPSessionManager *sessionManager = [[ALHTTPSessionManager alloc] initWithTarget:self
                                                                               selector:@selector(didFinishConnectionWithResult:)
                                                                          configuration:config];
    
    NSMutableURLRequest *request = [sessionManager.serialization requestWithMethod:requestInfo[@"httpMethod"] URLString:strURL parameters:requestInfo[@"param"]];
    
    [sessionManager POST:strURL parameters:requestInfo[@"param"] completionHandler:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:responseObject[@"notiIdentifier"]
                                                                object:responseObject
                                                              userInfo:nil];
        });
    }];
//    [sessionManager POST:strURL parameters:requestInfo[@"param"] completionHandler:^(NSURLSessionDataTask *task, id responseObject) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:responseObject[@"notiIdentifier"]
//                                                            object:responseObject
//                                                          userInfo:nil];
//    }];
    
    [sessionManager.session.delegateQueue addObserver:self forKeyPath:OPERATION_QUEUE_STATUS options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    
    
//    NSString *httpMethod = requestInfo[@"httpMethod"];
//    
//    if ([httpMethod isEqualToString:@"GET"]) {
//        [sessionManager GET:[NSURL URLWithString:strURL] parameters:requestInfo[@"param"]];
//    } else if ([httpMethod isEqualToString:@"POST"]) {
//        
//    } else if ([httpMethod isEqualToString:@"PUT"]) {
//        
//    } else if ([httpMethod isEqualToString:@"DELETE"]) {
//        
//    } else {
//        
//    }
    
}


#pragma mark -
#pragma mark NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if([keyPath isEqualToString:OPERATION_QUEUE_STATUS]) {
        NSLog(@"checking for operation Count : %d", [(NSOperationQueue *)object operationCount]);
        if ([(NSOperationQueue *)object operationCount] <= 0) {
            // 상단 네트워크 인디케이터 끔
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            // KVO 지움
            [(NSOperationQueue *)object removeObserver:self forKeyPath:@"operationCount" context:nil];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -
#pragma mark Connection Callback

- (void)didFinishConnectionWithResult:(id)result
{
    
    if ([result[@"type"] isEqualToString:@"image"]) {
        
        UIAsyncImageView *imageView = nil;
        
        if ([result[@"customParam"][@"imageView"] isKindOfClass:[UIAsyncImageView class]]) {
            imageView = (UIAsyncImageView *)result[@"customParam"][@"imageView"];
        }
        
        [imageView setImageForReceivedURL:result[@"url"]];
        
    } else  {
        [[NSNotificationCenter defaultCenter] postNotificationName:result[@"notiIdentifier"]
                                                            object:result
                                                          userInfo:nil];
    }
}

@end
