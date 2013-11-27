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
    self.URLString = @"http://aiden.gonetis.com:8080"; // Typing you URL
}

- (IBAction)sendSimpleDataTask:(id)sender {
    [_alt sendRequestForUserInfo:@{ @"url": [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/standardinformation"] }];
}

- (IBAction)sendDataTaskForGET:(id)sender {
    [_alt sendRequestForUserInfo:@{ @"url": [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/users/528507acf5d3160c3c000018"] }];
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
                                        @"url"        : [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/users/528507acf5d3160c3c000018"],
                                        @"httpMethod" : @"put",
                                        @"param"  : @{ @"username": @"aidenjlee22" }
                                   }];
}

- (IBAction)sendDataTaskForDELETE:(id)sender {
    [_alt sendRequestForUserInfo:@{
                                        @"url"        : [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/users/528507acf5d3160c3c000018"],
                                        @"httpMethod" : @"delete"
                                   }];
}

- (IBAction)sendUploadTask:(id)sender {
    
    NSURLSessionConfiguration  *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 구성 ​​개체 및 self 대리자를 지정하여 세션을 만듭니다.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil ];
    
    // 업로드 할 파일의 이름을 적당히 설정합니다.
//    double timeUploaded = [[NSDate date] timeIntervalSince1970];
    NSString *fileNameUploaded = @"uploadFile";
//    fileNameUploaded = [fileNameUploaded stringByAppendingString:[NSString stringWithFormat:@"% f", timeUploaded]];
//    fileNameUploaded = [fileNameUploaded stringByAppendingString:@"dat" ];
    
//    // 서버 측 폼 <input type="file" name="file">에 맞추어 둡니다.
//    NSString *nameUploaded = @"file" ;
//    NSString *post = @"mogmog" ;
    
    // 1,000,000 바이트의 의미없는 데이터를 생성합니다.
    NSMutableData *md = [[NSMutableData alloc] initWithLength:1000000];
    // create a buffer to hold the data for the asset's image
//    uint8_t *buffer = (Byte*)malloc(representation.size);// copy the data from the asset into the buffer
//    NSUInteger length = [representation getBytes:buffer fromOffset: 0.0  length:representation.size error:nil];
//    
//    // convert the buffer into a NSData object, free the buffer after
//    NSData *image = [[NSData alloc] initWithBytesNoCopy:buffer length:representation.size freeWhenDone:YES];
    
    NSMutableURLRequest *req = nil;
    req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/games/gameresult"]]];
    
    [req setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [req setTimeoutInterval:30.0];
    [req setHTTPMethod:@"POST"];
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"0xKhTmLbOuNdArY";
    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", fileNameUploaded] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"image/jpeg"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:md];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [urlRequest setHTTPBody:body];
    
    // boundary에 임의의 문자열을 설정합니다.
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [req addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; \r\n", fileNameUploaded] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:md];
    [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [req setHTTPBody:body];
    
    // 작업 개체를 만듭니다.
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:req fromData:md completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", data);
    }];
    [task resume];
    
//    // bodyData
//    [_alt sendRequestForUserInfo:@{
//                                        @"url"        : [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/games/gameresult"],
//                                        @"task"       : @"upload",
//                                        @"param"      : @{ @"uploadData": [[NSMutableData alloc] initWithLength:1000000] } // 1e6
//                                   }];
    
//    // fileURL
//    [_alt sendRequestForUserInfo:@{
//                                   @"url"        : [NSString stringWithFormat:@"%@%@", self.URLString,  @"/v1/picture/something"],
//                                   @"httpMethod" : @"post",
//                                   @"param"  : @{ @"_id": @"528d25bf8055296c3a000001" }
//                                   }];
    
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
