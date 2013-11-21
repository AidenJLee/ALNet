//
//  ALMainViewController.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 20..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALMainViewController.h"

@interface ALMainViewController ()

@end

@implementation ALMainViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _alt = [[ALTransaction alloc] initWithTarget:self
                                     successSelector:@selector(recieveSuccess:)
                                     failureSelector:@selector(recieveFailure:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [_alt sendRequestForUserInfo:@{
//                                   @"url": @"http://aiden.gonetis.com:8080/v1/standardinformation",
//                                   @"httpMethod" : @"post",
//                                   @"param": @{ @"aa": @"postValue"}
//                                   }];
    
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
