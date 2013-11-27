//
//  ALSessionManager.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "AppDelegate.h"

#import "ALNetManager.h"
#import "ALSessionManager.h"
#import "ALSessionManager+TaskDelegate.h"
#import "ALSessionManager+DataTaskDelegate.h"
#import "ALSessionManager+DownloadTaskDelegate.h"

static void *ContextTaskState = &ContextTaskState;

@interface ALSessionManager ()

@property (nonatomic, strong, readwrite) NSURLSession *session;

@end


@implementation ALSessionManager


#pragma mark -
#pragma mark Initialization
- (instancetype)initWithTarget:(id)target
                      selector:(SEL)selector
                 configuration:(NSURLSessionConfiguration *)configuration

{
    
    self = [super init];
    if (self) {
        
        if (!configuration) {
            configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            
        }
		_target   = target;
		_selector = selector;
        _session  = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[ALNetManager sharedInstance].operationQueue];
        _serialization = [[ALSerialization alloc] init];
        
	}
	return self;
    
}


#pragma mark -
#pragma mark - ALSessionManager Method Implement
- (void)invalidateSessionCancel
{
    [self.session invalidateAndCancel];
}

- (void)invalidateAndFinishTasksCancel
{
    [self.session finishTasksAndInvalidate];
}

- (NSArray *)getTasksWithTaskType:(NSString *)taskType
{
    
    __block NSArray *tasks = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if ([taskType isEqualToString:@"dataTasks"]) {
            tasks = dataTasks;
        } else if ([taskType isEqualToString:@"uploadTasks"]) {
            tasks = uploadTasks;
        } else if ([taskType isEqualToString:@"downloadTasks"]) {
            tasks = downloadTasks;
        } else if ([taskType isEqualToString:@"tasks"]) {
            tasks = [@[dataTasks, uploadTasks, downloadTasks] valueForKeyPath:@"@unionOfArrays.self"];
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return tasks;
    
}

// NSKeyValueObserving For Task Method Implement
- (void)addObserverForTask:(id)task
{
    [task addObserver:self forKeyPath:OBSERVE_STATE options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:ContextTaskState];
}


#pragma mark -
#pragma mark - NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    
    NSLog(@"Log : %s   Function : %s  Source Line : %d" , __FILE__, __FUNCTION__, __LINE__);
    if (error) {
        NSLog(@" %@", error.description);
    }
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSLog(@"Log : %s   Function : %s  Source Line : %d" , __FILE__, __FUNCTION__, __LINE__);
}


@end
