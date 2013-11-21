//
//  ALSessionManager.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "AppDelegate.h"

#import "ALSessionManager.h"
#import "ALSessionManager+TaskDelegate.h"
#import "ALSessionManager+DataTaskDelegate.h"
#import "ALSessionManager+DownloadTaskDelegate.h"


static void *ContextTaskState = &ContextTaskState;

@interface ALSessionManager ()

@property (readwrite, strong, nonatomic) NSURLSession *session;

@end


#define MAX_OPERATIONQUEUE_COUNT 5
#define SESSION_DOWNLOAD_ID (@"com.entist.download.session")

@implementation ALSessionManager


#pragma mark -
#pragma mark Initialization
- (instancetype)initWithConfig:(NSURLSessionConfiguration *)configuration
{
    
    self = [super init];
    if (self) {
        if (configuration) {
            _session = [self createSessionWithConfig:configuration];
        } else {
            _session = [self backgroundSession];
        }
        
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
            _sharedQueue.name = @"com.entist.ALNet.operationQueue";
            _sharedQueue.maxConcurrentOperationCount = MAX_OPERATIONQUEUE_COUNT;
        });
        
    }
    
    // 생성된 인스턴스를 리턴한다.
    return _sharedQueue;
    
}


#pragma mark -
#pragma mark - NSURLSession Create Method Implement
- (NSURLSession *)createSessionWithConfig:(NSURLSessionConfiguration *)configuration
{
	
    static NSURLSession *_customSession = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_customSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[self.class operationQueue]];
	});
	return _customSession;
    
}

- (NSURLSession *)backgroundSession
{
    
	static NSURLSession *_backgroundSession = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:SESSION_DOWNLOAD_ID];
		_backgroundSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[self.class operationQueue]];
	});
	return _backgroundSession;
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


// TODO: TaskDelegate에서 세부 구현이 필요합니다.  - Task NSKeyValueObserving으로 관찰중인 값 컨트롤
#pragma mark -
#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if (context == ContextTaskState && [keyPath isEqualToString:@"state"]) {
        
        NSString *notificationName = nil;
        switch ([(NSURLSessionTask *)object state]) {
                
            case NSURLSessionTaskStateRunning:
                break;
                
            case NSURLSessionTaskStateSuspended:
                notificationName = @"TaskDidSuspend";
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
    return [self addObserverWithTask:[self.session dataTaskWithRequest:request completionHandler:completionHandler]];
}

#pragma mark -
#pragma makr - UploadTask Method Implement
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromFile:(NSURL *)fileURL
                                completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    return [self addObserverWithTask:[self.session uploadTaskWithRequest:request fromFile:fileURL completionHandler:completionHandler]];
}

- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromData:(NSData *)bodyData
                                completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    return [self addObserverWithTask:[self.session uploadTaskWithRequest:request fromData:bodyData completionHandler:completionHandler]];;
}


#pragma mark -
#pragma makr - Download Task Method Implement
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                    completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler
{
    return [self addObserverWithTask:[self.session downloadTaskWithRequest:request completionHandler:completionHandler]];;
}

- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                       completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler
{
    return [self addObserverWithTask:[self.session downloadTaskWithResumeData:resumeData completionHandler:completionHandler]];
}

// Add Observer Method Implement
- (id)addObserverWithTask:(id)task
{
    [task addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:ContextTaskState];
    return task;
}


@end
