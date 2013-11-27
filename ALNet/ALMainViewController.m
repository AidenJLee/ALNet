//
//  ALMainViewController.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 20..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALMainViewController.h"
#import "ALHTTPSessionManager.h"
#import "ALStringConvertor.h"

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
    self.URLString = @"http://ec2-54-238-212-83.ap-northeast-1.compute.amazonaws.com:8080"; // Typing you URL
}

- (IBAction)sendSimpleDataTask:(id)sender {
    [_alt sendRequestForUserInfo:@{ @"url": [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/standardinformation"] }];
}

- (IBAction)sendDataTaskForGET:(id)sender {
    [_alt sendRequestForUserInfo:@{ @"url": [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/standardinformation"] }];
}

- (IBAction)sendDataTaskForPost:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                        @"url"        : [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/users/find"],
                                        @"httpMethod" : @"post",
                                        @"param"      : @{ @"_id": @"528d25bf8055296c3a000001" }
                                   }];
}

- (IBAction)sendDataTaskForPUT:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                        @"url"        : [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/users/528d25bf8055296c3a000001"],
                                        @"httpMethod" : @"put",
                                        @"param"  : @{ @"nickname": @"aidenjlee" }
                                   }];
}

- (IBAction)sendDataTaskForDELETE:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                        @"url"        : [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/users/528d25bf8055296c3a000001"],
                                        @"httpMethod" : @"delete"
                                   }];
}

- (IBAction)sendUploadTask:(id)sender {
    // bodyData
    [_alt sendRequestForUserInfo:@{
                                        @"url"        : [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/picture/something"],
                                        @"httpMethod" : @"post",
                                        @"bodyData"  : [[NSMutableData alloc] initWithLength:1000000] // 1e6
                                   }];
    
    // fileURL
    [_alt sendRequestForUserInfo:@{
                                   @"url"        : [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/picture/something"],
                                   @"httpMethod" : @"post",
                                   @"param"  : @{ @"_id": @"528d25bf8055296c3a000001" }
                                   }];
    
}

- (IBAction)sendDownloadTask:(id)sender {
    [_alt sendRequestForUserInfo:@{ @"url": [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/picture/something"] }];
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
}

- (void)recieveFailure:(id)result
{
    NSLog(@"recieveFailure : %@", result);
}

@end
