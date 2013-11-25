//
//  ALMainViewController.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 20..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALMainViewController.h"
#import "ALHTTPSessionManager.h"

@interface ALMainViewController ()

@end

@implementation ALMainViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _alt = [[ALTransactionHTTP alloc] initWithTarget:self
                                     successSelector:@selector(recieveSuccess:)
                                     failureSelector:@selector(recieveFailure:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)receiveResult:(id)result
{
    NSLog(@"result : %@", result);
}

- (IBAction)sendPost:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                   @"url"        : @"http://ec2-54-238-212-83.ap-northeast-1.compute.amazonaws.com:8080/v1/users/create",
                                   @"httpMethod" : @"post",
                                   @"type"       : @"json",
                                   @"param"  : @{
                                           @"appid": @"asfdsfa",
                                           @"nickname": @"aidenjlee",
                                           @"password": @"entist",
                                           @"openidname": @"gamecenter",
                                           @"openidid": @"1412523515",
                                           @"openidtype": @"FACEBOOK",
                                           @"country": @"ko_kr",
                                           @"locale": @"seoul_korea"
                                           }
                                   }];
}

- (IBAction)sendPostForFind:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                   @"url"        : @"http://ec2-54-238-212-83.ap-northeast-1.compute.amazonaws.com:8080/v1/users/find",
                                   @"httpMethod" : @"post",
                                   @"type"       : @"json",
                                   @"param"  : @{ @"_id": @"528d25bf8055296c3a000001" }
                                   }];
}

- (IBAction)sendPostForLogin:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                   @"url"        : @"http://ec2-54-238-212-83.ap-northeast-1.compute.amazonaws.com:8080/v1/users/login",
                                   @"httpMethod" : @"post",
                                   @"type"       : @"json",
                                   @"param"  : @{
                                                    @"appid": @"asfdsfa",
                                                    @"openidid": @"1412523515",
                                                    @"openidtype": @"FACEBOOK"
                                                  }
                                   }];
}

- (IBAction)sendPostForMakeGame:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                   @"url"        : @"http://ec2-54-238-212-83.ap-northeast-1.compute.amazonaws.com:8080/v1/games/makegame",
                                   @"httpMethod" : @"post",
                                   @"type"       : @"json",
                                   @"param"  : @{
                                           @"appid": @"asfdsfa",
                                           @"creatorid": @"528d25bf8055296c3a000001",
                                           @"opponentid": @"528d26c9453b5e973a000001",
                                           }
                                   }];
}

- (IBAction)sendPostForStartGame:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                   @"url"        : @"http://ec2-54-238-212-83.ap-northeast-1.compute.amazonaws.com:8080/v1/games/startgame",
                                   @"httpMethod" : @"post",
                                   @"type"       : @"json",
                                   @"param"  : @{
                                           @"gameid": @"528d9f8801eaf03c3d000001",
                                           @"opponentid": @"528d25bf8055296c3a000001"
                                           // 게임 시작이니까 게임 만든 사람 아이디 ( 이정보는 노티로 전송 됨 )
                                           }
                                   }];
}

- (IBAction)sendPostForCompleteTurn:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                   @"url"        : @"http://ec2-54-238-212-83.ap-northeast-1.compute.amazonaws.com:8080/v1/games/completeturn",
                                   @"httpMethod" : @"post",
                                   @"type"       : @"json",
                                   @"param"  : @{
                                           @"appid": @"asfdsfa",
                                           @"openidid": @"1412523515",
                                           @"openidtype": @"FACEBOOK"
                                           }
                                   }];
}

- (IBAction)sendPostForCompleteRound:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                   @"url"        : @"http://ec2-54-238-212-83.ap-northeast-1.compute.amazonaws.com:8080/v1/games/completeround",
                                   @"httpMethod" : @"post",
                                   @"type"       : @"json",
                                   @"param"  : @{
                                           @"appid": @"asfdsfa",
                                           @"openidid": @"1412523515",
                                           @"openidtype": @"FACEBOOK"
                                           }
                                   }];
}

- (IBAction)sendPostForStartRound:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                   @"url"        : @"http://ec2-54-238-212-83.ap-northeast-1.compute.amazonaws.com:8080/v1/games/startround",
                                   @"httpMethod" : @"post",
                                   @"type"       : @"json",
                                   @"param"  : @{
                                           @"appid": @"asfdsfa",
                                           @"openidid": @"1412523515",
                                           @"openidtype": @"FACEBOOK"
                                           }
                                   }];
}

- (IBAction)sendPostForCompleteGame:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                   @"url"        : @"http://ec2-54-238-212-83.ap-northeast-1.compute.amazonaws.com:8080/v1/games/completegame",
                                   @"httpMethod" : @"post",
                                   @"type"       : @"json",
                                   @"param"  : @{
                                           @"appid": @"asfdsfa",
                                           @"openidid": @"1412523515",
                                           @"openidtype": @"FACEBOOK"
                                           }
                                   }];
}

- (IBAction)sendPostForGameResult:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                   @"url"        : @"http://ec2-54-238-212-83.ap-northeast-1.compute.amazonaws.com:8080/v1/games/gameresult",
                                   @"httpMethod" : @"post",
                                   @"type"       : @"json",
                                   @"param"  : @{
                                           @"appid": @"asfdsfa",
                                           @"openidid": @"1412523515",
                                           @"openidtype": @"FACEBOOK"
                                           }
                                   }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)recieveSuccess:(id)result
{
    NSDictionary *value = result;
    NSLog(@"recieveSuccess : %@", [NSString stringWithFormat:@"%@", value]);
    [_textView setText:[NSString stringWithFormat:@"%@", value]];
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)recieveFailure:(id)result
{
    NSLog(@"recieveFailure : %@", result);
}

@end
