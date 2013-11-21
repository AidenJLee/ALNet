//
//  ALHTTPSessionManager.m
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 19..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALHTTPSessionManager.h"

@implementation ALHTTPSessionManager


#pragma mark -
#pragma mark Initialization
- (id)initWithConfig:(NSURLSessionConfiguration *)configuration
              Target:(id)target
            selector:(SEL)selector
         requestInfo:(NSDictionary *)requestInfo
{
    
    self = [super initWithConfig:configuration];
    if (self) {
		_target      = target;
		_selector    = selector;
        _requestInfo = requestInfo;
        
        _serialization = [[ALSerialization alloc] init];
	}
	return self;
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ Description: %p, session: %@, operationQueue: %@", NSStringFromClass([self class]), self, self.session, self.session.delegateQueue];
}


#pragma mark -
#pragma mark - Session Task Operation
- (void)taskOperationForhttpMethod:(NSString *)httpMethod
{
    NSString *strURL = nil;
    
    strURL = _requestInfo[@"url2"];
    
    if (strURL == nil || [strURL isEqualToString:@""]) {
        strURL = _requestInfo[@"url"];
    }
    
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 파라메터 수집
    NSMutableString *strParam = [[NSMutableString alloc] init];
    
    for (NSString *key in [_requestInfo[@"param"] allKeys]) {
        
        if (strParam.length != 0) {
            [strParam appendFormat:@"&%@=%@", key, _requestInfo[@"param"][key]];
        } else {
            [strParam appendFormat:@"%@=%@",  key, _requestInfo[@"param"][key]];
        }
        
    }
    
    // get 방식
    if ([httpMethod isEqualToString:@"get"]) {
        
        NSMutableURLRequest *request = nil;
        
        // 앞에 ?를 붙여준다.
        if ([strParam length] != 0) {
            [strParam insertString:@"?" atIndex:0];
        }
        
        NSString *strEncodeParam = [strParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        request = [[NSMutableURLRequest alloc] init];
        
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];   // 캐쉬 사용 안함
        [request setTimeoutInterval:15.0];                              // 15초 타임아웃
        [request setHTTPMethod:@"GET"];                                 // GET 방식전송
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", strURL, strEncodeParam]]];
        
        if (_requestInfo[@"common"][@"httpHeaderField"]) {
            for (NSString *headerFieldKey in [_requestInfo[@"common"][@"httpHeaderField"] allKeys]) {
                [request setValue:_requestInfo[@"common"][@"httpHeaderField"][headerFieldKey] forHTTPHeaderField:headerFieldKey];
            }
        }
        
        NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                
            }
            id resultObject = [self.serialization objectForResponse:response data:data];
            [_target performSelectorOnMainThread:_selector withObject:resultObject waitUntilDone:NO];
        }];
        [task resume];
    }
}

- (NSMutableURLRequest *)requestForType:(NSString *)type parameters:(NSDictionary *)parameters
{
    return nil;
}


#pragma mark -
#pragma mark - HTTP Public Method Implement
- (void)GET:(NSURL *)URL parameters:(NSDictionary *)parameters
{
    
    if ([[URL path] length] > 0 && ![[URL absoluteString] hasSuffix:@"/"]) {
        URL = [URL URLByAppendingPathComponent:@""];
    }
//    NSMutableURLRequest *request =
    NSURLSessionDataTask *task = [self dataTaskWithRequest:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        [_target performSelectorOnMainThread:_selector withObject:[self.serialization objectForResponse:response data:data] waitUntilDone:NO];
    }];
    [task resume];
    
}

- (void)POST:(NSURL *)URL parameters:(NSDictionary *)parameters
{
    
    //    NSMutableURLRequest *request =
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
//            responseObject = [manager.responseSerializer responseObjectForResponse:task.response data:[NSData dataWithData:self.mutableData] error:&serializationError];
            [self serializationWithResponse:response receivedData:data];
        } else {
            
        }
        [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
    }];
    [task resume];
    
}

- (void)PUT:(NSURL *)URL parameters:(NSDictionary *)parameters
{
    
    //    NSMutableURLRequest *request =
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            [self serializationWithResponse:response receivedData:data];
        } else {
            
        }
        [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
    }];
    [task resume];
    
}

- (void)DELETE:(NSURL *)URL parameters:(NSDictionary *)parameters
{
    
    //    NSMutableURLRequest *request =
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:nil completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            [self serializationWithResponse:response receivedData:data];
        } else {
            
        }
        [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
    }];
    [task resume];
    
}

#pragma makr -
#pragma mark - HTTPRequest Serialization


#pragma makr -
#pragma mark - HTTPResponse Serialization
- (id)serializationWithResponse:(NSURLResponse *)res receivedData:(NSData *)data
{
    
    // Data를 JSONObject로 변환
    return [self.serialization objectForResponse:res data:data];
    
}

@end
