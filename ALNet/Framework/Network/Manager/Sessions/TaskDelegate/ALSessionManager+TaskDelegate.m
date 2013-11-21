//
//  ALSessionManager+TaskDelegate.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 19..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALSessionManager+TaskDelegate.h"

@implementation ALSessionManager (TaskDelegate)

#pragma mark -
#pragma mark - NSURLSessionTaskDelegate
/* 특정 Task와 관련 된 마지막 메세지가 전송 되면 호출된다. Error = nil이면 오류 없이 task가 완료 된것이다.  */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    NSLog(@"Log : %s   Function : %s  Source Line : %d" , __FILE__, __FUNCTION__, __LINE__);
    if (!error) {
        NSLog(@"task response object : %@", task.response);
    }
    
//    if (self.progressAction){
//        self.progressAction((double)task.countOfBytesReceived, (double)task.countOfBytesExpectedToReceive);
//    }
//    [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
}

/* 업도르 종료 후 응답이 Redirection되는 경우 호출된다. */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSLog(@"Log : %s   Function : %s  Source Line : %d" , __FILE__, __FUNCTION__, __LINE__);
}

/* The task has received a request specific authentication challenge.
 * If this delegate is not implemented, the session specific authentication challenge
 * will *NOT* be called and the behavior will be the same as using the default handling
 * disposition.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSLog(@"Log : %s   Function : %s  Source Line : %d" , __FILE__, __FUNCTION__, __LINE__);
}

/* Sent if a task requires a new, unopened body stream.  This may be
 * necessary when authentication has failed for any request that
 * involves a body stream.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
    
}

/* Sent periodically to notify the delegate of upload progress.  This
 * information is also available as properties of the task.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
//    self.uploadProgress.totalUnitCount = totalBytesExpectedToSend;
//    self.uploadProgress.completedUnitCount = totalBytesSent;
}

@end
