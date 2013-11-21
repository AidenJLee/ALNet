//
//  ALSessionManager+DownloadTaskDelegate.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 19..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALSessionManager+DownloadTaskDelegate.h"
#import "ALCacheManager.h"

NSString * const DOWNLOAD_SUCCESS_NOTI = @"DownloadTaskDidSuccessNotification";
NSString * const FILE_SAVE_ERROR_NOTI  = @"FileSaveFailNotification";

@implementation ALSessionManager (DownloadTaskDelegate)

#pragma mark -
#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSLog(@"Log : %s   Function : %s  Source Line : %d" , __FILE__, __FUNCTION__, __LINE__);
    
    /*
     URL주소에 Extension이 있어야 한다. 없다면 아래와 같이 Type에 따라서 붙여야 한다.
     if ([[destinationURL pathExtension] isEqualToString:@""]) {
     destinationURL = [destinationURL URLByAppendingPathExtension:@"png"];
     }
     */
    
    self.downloadedFileURL = [[downloadTask originalRequest] URL];
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSLog(@"downloadFileURL : %@", self.downloadedFileURL);
    if (self.downloadedFileURL) {
        if ([[ALCacheManager sharedInstance] saveData:data withURL:self.downloadedFileURL]) {
            NSDictionary *dataDic = @{ @"result": @(YES), @"URL": self.downloadedFileURL };
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_SUCCESS_NOTI object:downloadTask userInfo:dataDic];
        } else {
            NSDictionary *dicForError = @{ @"result": @(NO), @"error": @"fileManager save error" };
            [[NSNotificationCenter defaultCenter] postNotificationName:FILE_SAVE_ERROR_NOTI object:downloadTask userInfo:dicForError];
        }
    }
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
//    self.downloadProgress.totalUnitCount = totalBytesExpectedToWrite;
//    self.downloadProgress.completedUnitCount = totalBytesWritten;

}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{

//    self.downloadProgress.totalUnitCount = expectedTotalBytes;
//    self.downloadProgress.completedUnitCount = fileOffset;

}

@end
