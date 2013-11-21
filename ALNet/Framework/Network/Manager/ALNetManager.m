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
#pragma mark Init

- (instancetype)init
{
    
    self = [super init];
    
    if (self) {
        // do something
        // anything for init
    }
    
    return self;
    
}


#pragma mark -
#pragma mark ALNetworkManagerProtocol Method Implement

- (void)requestWithRequestInfo:(id)requestInfo
{
    
    NSString *srtURL = requestInfo[@"url"];
    
    if (!srtURL) {
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Configuration Custom 가능 - 미채ㅜ랴혁ㅁ샤ㅐㅜ.ㅗ
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    if ([requestInfo[@"task"] isEqualToString:@"DOWNLOAD"]) {
        config = nil;
    }
    
    ALHTTPSessionManager *sessionManager = [[ALHTTPSessionManager alloc] initWithConfig:config
                                                                                 Target:self
                                                                               selector:@selector(didFinishConnectionWithResult:)
                                                                            requestInfo:requestInfo];
    [sessionManager getTasksWithTaskType:@""];
    
}


#pragma mark -
#pragma mark Connection Callback

- (void)didFinishConnectionWithResult:(id)result
{
    
    //    if (sessionManager.session.delegateQueue.operationCount <= 1) {
    //        // 상단 네트워크 인디케이터 끔
    //        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //    }
    
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
