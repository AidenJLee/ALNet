//
//  ALCacheManager.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 12..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALCacheManager.h"

@implementation ALCacheManager


#pragma mark -
#pragma mark Singleton Creation & Destruction Method

static ALCacheManager *__instance = nil;
+ (ALCacheManager *)sharedInstance
{
    
    if (!__instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __instance = [[ALCacheManager alloc] init];
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

- (id)init
{
    
    self = [super init];
    if (self) {
        _strPrefix    = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];;
        _URLCachePath = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    }
    return self;
    
}


#pragma mark -
#pragma mark Cache Method Implement
/*! NSURL주소를 통해 Cache되어 있는 UIImage를 가져오는 메소드
 * \param URL - Server에서 다운받는 주소 URL
 * \returns A newly created UIImage instance
 */
- (UIImage *)imageForURL:(NSURL *)URL
{
    
    if (!URL) {
        return nil;
    }
    
    NSURL *destinationPath = [self.URLCachePath URLByAppendingPathComponent:[self.strPrefix stringByAppendingString:[URL path]]];
    
    NSError *error = nil;
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:destinationPath options:NSDataReadingUncached error:&error]];
    
    // 이미지가 정상적이지 않으면 삭제 한다.
    if (!image) {
        NSError *removeError = nil;
        [[NSFileManager defaultManager] removeItemAtURL:destinationPath error:&removeError];
    }
    
    return image;
    
}

/*! NSURL주소를 통해 Cache되어 있는 NSData를 가져오는 메소드
 * \param URL - Server와 통신하는 고유한 URL주소
 * \returns A newly created NSData instance
 */
- (NSData *)dataForURL:(NSURL *)URL
{
    
    if (!URL) {
        return nil;
    }
    
    NSURL *destinationPath = [self.URLCachePath URLByAppendingPathComponent:[self.strPrefix stringByAppendingString:[URL path]]];
    
    NSError *error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:destinationPath options:NSDataReadingUncached error:&error];
    
    // 데이터가 정상적이지 않으면 삭제 한다.
    if (!data) {
        [[NSFileManager defaultManager] removeItemAtURL:destinationPath error:NULL];
    }
    
    return data;
    
}

/*! NSURL주소를 통해 Cache되어 있는 Data를 지우는 메소드
 * \param URL - Server와 통신하는 고유한 URL주소
 * \returns 메소드 실행 결과가 boolean형태로 반환된다.
 */
- (BOOL)removeDataForURL:(NSURL *)URL
{
    
    // File Path 가져오기
    NSURL *destinationPath = [self.URLCachePath URLByAppendingPathComponent:[self.strPrefix stringByAppendingString:[URL path]]];
    return [[NSFileManager defaultManager] removeItemAtURL:destinationPath error:NULL];
    
}

/*! Data를 저장하는 메소드
 *  URL값은 고유하다라는 전제하에 서버에서 다운받는 URL주소를 기반으로
 *  폴더를 생성하고 그곳에 데이터를 저장하는 형식이다.
 * \param URL - Server와 통신하는 고유한 URL주소
 * \returns 메소드 실행 결과가 boolean형태로 반환된다.
 */
- (BOOL)saveData:(NSData *)data withURL:(NSURL *)URL
{
    
    // File Path 가져오기
    NSURL *destinationPath = [self.URLCachePath URLByAppendingPathComponent:[self.strPrefix stringByAppendingString:[URL path]]];
    
    // Directory 생성하기
    NSError *createError = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtURL:[destinationPath URLByDeletingLastPathComponent]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&createError]) {
        return NO;
    }
    
    NSError *error = nil;
    // 파일 저장
    return [data writeToURL:destinationPath options:NSDataWritingFileProtectionComplete error:&error];
    
}

/*! 저장되어 있는 공간이 지정한 limit을 넘으면 지우는 메소드
 * \param limit - 저장 된 데이터를 지우는 기준 용량
 * \returns None.
 */
- (void)cleanStorageForLimit:(long long int)limit
{
    
    NSURL *cacheURLPath = [self.URLCachePath URLByAppendingPathComponent:self.strPrefix];
    
    // 로컬에 저장 된 파일 사이즈가 Limit을 넘으면 삭제한다
    long long int cachefileSizes = [self checkForCacheSizeWithURL:cacheURLPath];
    
    if (cachefileSizes > limit) {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] removeItemAtURL:cacheURLPath error:&error]) {
            NSLog(@"Remove Error : %@", [error description]);
        }
    }
    
}

// 로컬 파일 사이즈 체크
- (unsigned long long int)checkForCacheSizeWithURL:(NSURL *)URLPath {
    
    NSArray *arrCacheFileList = [[NSFileManager defaultManager] subpathsAtPath:[URLPath path]];
    NSEnumerator *cacheEnumerator = [arrCacheFileList objectEnumerator];
    NSString *strCacheFilePath = nil;
    
    unsigned long long int datasSize = 0;
    NSError *error = nil;
    
    while (strCacheFilePath = [cacheEnumerator nextObject]) {
        NSDictionary *dicCacheFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[[URLPath path] stringByAppendingPathComponent:strCacheFilePath] error:&error];
        datasSize += [dicCacheFileAttributes fileSize];
    }
    NSLog(@"Local storage File Size = %lld", datasSize);
    return datasSize;
    
}

@end
