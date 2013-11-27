//
//  ALNetManager.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALNetManager.h"
#import "ALHTTPSessionManager.h"
#import "ALSessionConfiguration.h"
#import "UIAsyncImageView.h"


static void *QueueContext = &QueueContext;

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
        _operationQueue = [self.class operationQueue];
    }
    
    return self;
    
}


#pragma mark -
#pragma mark OperationQueue Method Implement
+ (NSOperationQueue *)operationQueue
{
    
    static NSOperationQueue *_sharedQueue = nil;
    // 만약 생성이 되어 있지 않다면
    if (!_sharedQueue) {
        
        // 한번만 생성을 한다.
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedQueue = [[NSOperationQueue alloc] init];
            _sharedQueue.name = OPERATIONQUEUE_NAME;
            _sharedQueue.maxConcurrentOperationCount = MAX_OPERATIONQUEUE_COUNT;
        });
        
    }
    
    // 생성된 인스턴스를 리턴한다.
    return _sharedQueue;
    
}


#pragma mark -
#pragma mark ALNetworkManagerProtocol Method Implement

- (void)requestWithRequestInfo:(id)requestInfo
{
    
    // Task에 따른 SessionConfiguration생성 - ALConfiguration.h에서 조정
    NSURLSessionConfiguration *config = [ALSessionConfiguration defaultConfiguration];
    
    if ([requestInfo[@"task"] isEqualToString:@"DOWNLOAD"]) {
        config = [ALSessionConfiguration backgroundConfiguration];
    }
    
    // ALHTTPSessionManager 생성
    ALHTTPSessionManager *sessionManager = [[ALHTTPSessionManager alloc] initWithTarget:self
                                                                               selector:@selector(didFinishConnectionWithResult:)
                                                                          configuration:config];
    [sessionManager sendHTTPWithRequestInfo:requestInfo];
    
    
    // 상단 네트워크 인디케이터 켬
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [sessionManager.session.delegateQueue addObserver:self forKeyPath:OBSERVE_STATE options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:QueueContext];
    
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
        [[NSNotificationCenter defaultCenter] postNotificationName:result[ALTRANSACTION_IDENTIFIER]
                                                            object:result
                                                          userInfo:nil];
    }
}


#pragma mark -
#pragma mark NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"keyPath : %@ " , keyPath);
    if([keyPath isEqualToString:OBSERVE_STATE]) {
        NSLog(@"checking for operation Count : %u", [(NSOperationQueue *)object operationCount]);
        if ([(NSOperationQueue *)object operationCount] <= 0) {
            // 상단 네트워크 인디케이터 끔
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"operationQueue status change");
//            // KVO 지움
//            [(NSOperationQueue *)object removeObserver:self forKeyPath:@"operationCount" context:nil];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



@end
