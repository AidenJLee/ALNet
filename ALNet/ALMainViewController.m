//
//  ALMainViewController.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 20..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALMainViewController.h"
#import "Standardinformation.h"

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
    
    [_AsyncImageView setImageForOriginalURLString:[NSURL URLWithString:@"http://cfile6.uf.tistory.com/image/137DC1484FC63A6B287B30"]
                                     thumbnailURL:[NSURL URLWithString:@"http://cfile22.uf.tistory.com/image/1755B30F4B41C93944903B"]];
}

- (IBAction)sendSimpleDataTask:(id)sender {
    [_alt sendRequestForUserInfo:@{ @"url": [Standardinformation sharedInstance].apis[@"users"] }];
}

- (IBAction)sendDataTaskForGET:(id)sender {
    [_alt sendRequestForUserInfo:@{ @"url": [Standardinformation sharedInstance].apis[@"users"] }];
}

- (IBAction)sendDataTaskForPost:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                        @"url"        : @"",
                                        @"httpMethod" : @"post",
                                        @"param"      : @{ @"_id": @"528d25bf8055296c3a000001" }
                                   }];
}

- (IBAction)sendDataTaskForPUT:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                        @"url"        : @"",
                                        @"httpMethod" : @"put",
                                        @"param"  : @{ @"username": @"aidenjlee" }
                                   }];
}

- (IBAction)sendDataTaskForDELETE:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                        @"url"        : @"",
                                        @"httpMethod" : @"delete"
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
}

- (void)recieveFailure:(id)result
{
    NSLog(@"recieveFailure : %@", result);
}

@end
