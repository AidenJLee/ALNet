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


// Add NSKeyValueObserving For Task Method Implement
- (void)addObserverForTask:(id)task
{
    [task addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:ContextTaskState];
}


#pragma mark -
#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    // TODO: TaskDelegate에서 세부 구현이 필요합니다.  - Task NSKeyValueObserving으로 관찰중인 값 컨트롤
    if (context == ContextTaskState && [keyPath isEqualToString:@"state"]) {
        
        NSString *notificationName = nil;
        switch ([(NSURLSessionTask *)object state]) {
                
            case NSURLSessionTaskStateRunning:
                notificationName = TASK_DID_START_NOTI;
                break;
                
            case NSURLSessionTaskStateSuspended:
                notificationName = TASK_DID_SUSPEND_NOTI;
                break;
                
            case NSURLSessionTaskStateCompleted:
                [object removeObserver:self forKeyPath:@"state" context:ContextTaskState];
                break;
                
            default:
                break;
                
        }
        
        if (notificationName) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:object];
            });
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}


#pragma mark -
#pragma mark - DataTask Method Implement
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    [self addObserverForTask:dataTask];
    return dataTask;
    
}

#pragma mark -
#pragma makr - UploadTask Method Implement
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromFile:(NSURL *)fileURL
                                completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    
    NSURLSessionUploadTask *uploadTask = [self.session uploadTaskWithRequest:request fromFile:fileURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    [self addObserverForTask:uploadTask];
    return uploadTask;
    
}

- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromData:(NSData *)bodyData
                                completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    
    NSURLSessionUploadTask *uploadTask = [self.session uploadTaskWithRequest:request fromData:bodyData];
    [self addObserverForTask:uploadTask];
    return uploadTask;
    
}


#pragma mark -
#pragma makr - Download Task Method Implement
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                    completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler
{
    
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request];
    [self addObserverForTask:downloadTask];
    return downloadTask;
    
}

- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                       completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler
{
    
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithResumeData:resumeData];
    [self addObserverForTask:downloadTask];
    return downloadTask;
    
}


@end
