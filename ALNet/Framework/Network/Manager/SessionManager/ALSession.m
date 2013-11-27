//
//  ALSession.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 27..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALSession.h"

#import "AppDelegate.h"

static void *ContextTaskState = &ContextTaskState;

@interface ALSession ()

@property (nonatomic, strong, readwrite) NSURLSession *session;

@end

@implementation ALSession


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


#pragma mark -
#pragma mark - NSKeyValueObserving For Task Method Implement
- (void)addObserverForTask:(id)task
{
    [task addObserver:self forKeyPath:OBSERVE_STATE options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:ContextTaskState];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"keyPath : %@ " , keyPath);
    // TODO: TaskDelegate에서 세부 구현이 필요합니다.  - Task NSKeyValueObserving으로 관찰중인 값 컨트롤
    if (context == ContextTaskState && [keyPath isEqualToString:OBSERVE_STATE]) {
        
        NSLog(@"Task : %d " , [(NSURLSessionTask *)object state]);
        NSString *notificationName = nil;
        switch ([(NSURLSessionTask *)object state]) {
                
            case NSURLSessionTaskStateRunning:
                notificationName = TASK_DID_START_NOTI;
                break;
                
            case NSURLSessionTaskStateSuspended:
                notificationName = TASK_DID_SUSPEND_NOTI;
                break;
                
            case NSURLSessionTaskStateCompleted:
                [object removeObserver:self forKeyPath:OBSERVE_STATE context:ContextTaskState];
                break;
                
            default:
                break;
                
        }
        
        if (notificationName) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:object];
            });
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
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
