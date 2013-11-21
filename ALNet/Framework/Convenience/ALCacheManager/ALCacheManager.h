//
//  ALCacheManager.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 12..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ALCacheManager : NSObject

@property (strong, nonatomic) NSString *strPrefix;
@property (strong, nonatomic) NSURL *URLCachePath;


#pragma mark -
#pragma mark Singleton Creation & Destruction Method
+ (ALCacheManager *)sharedInstance;
+ (void)releaseSharedInstance;


#pragma mark -
#pragma mark Cache Management Method
- (UIImage *)imageForURL:(NSURL *)URL;
- (NSData *)dataForURL:(NSURL *)URL;

- (BOOL)removeDataForURL:(NSURL *)URL;
- (BOOL)saveData:(NSData *)data withURL:(NSURL *)URL;

- (void)cleanStorageForLimit:(long long int)limit;

@end
