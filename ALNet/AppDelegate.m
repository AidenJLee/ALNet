//
//  AppDelegate.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "ALCacheManager.h"
#import "Standardinformation.h"

NSString * const STANDARDINFORMATION_URL = @"";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.mainStoryBoard = [UIStoryboard storyboardWithName:@"ALMain" bundle:nil];
    self.window.rootViewController = [self.mainStoryBoard instantiateInitialViewController];
    
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [ALCacheManager releaseSharedInstance];
    [Standardinformation releaseSharedInstance];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Cache파일이 30메가가 넘으면 삭제한다.
    [[ALCacheManager sharedInstance] cleanStorageForLimit:30.0f * 1024.0f * 1024.0f];
    
    // 기준정보를 가져올 수 있는 URL을 설정해준다.
    [Standardinformation sharedInstance].URLString = STANDARDINFORMATION_URL;
    
    if (![Standardinformation sharedInstance].lastUpdateDate) { // 어플 첫 기동 (관련 정보 init)
        [[Standardinformation sharedInstance] standardInfomationInitialize:^(BOOL success, id result) {
            
        }];
    } else {    // 어플 재실행
        [[Standardinformation sharedInstance] standardInformationUpdate:^(BOOL success, id result) {
            
        }];
    }
    
    // 마지막 업데이트로부터 얼마만큼의 시간이 지났는지 체크하여 동작 여부 ex) 30분
    if ([[Standardinformation sharedInstance] isTimeChangesAfterAddingCertainNumber:(30)]) {
        
    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
