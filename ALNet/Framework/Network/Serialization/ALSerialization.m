//
//  ALSerialization.m
//  AIDENJLEENetworking
//
//  Created by HoJun Lee on 2013. 11. 12..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALSerialization.h"

@implementation ALSerialization

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.statusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
    }
    
    return self;
}

// Check response - Status Code & MINE Type (@"application/json", @"text/json", @"text/plain")
- (NSDictionary *)validateResponse:(NSHTTPURLResponse *)response data:(NSData *)data
{
    
    NSString *errorDescription = nil;
    
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    // 상태 코드가 정상 범위 내에 있고
    if ([self.statusCodes containsIndex:(NSUInteger)res.statusCode]) {
        
        NSString *mineType = [res MIMEType];
        if ([mineType isEqualToString:@"text/plain"]) {
            // MINE Type이 파싱 가능한 오브젝트면 YES (Node.JS Buffer Type으로 반환하면 plain으로 반환 됨)
            return nil;
        }
        if ([mineType isEqualToString:@"text/json"] ||
            [mineType isEqualToString:@"application/json"]) {
            
            // MINE Type이 파싱 가능한 오브젝트면 YES
            return nil;
        
        } else if ([mineType isEqualToString:@"text/html"]) {   // 에러 페이지가 오면?
            
            errorDescription = [NSString stringWithFormat:@"%ld %@ - %@",
                                (long)res.statusCode,
                                [NSHTTPURLResponse localizedStringForStatusCode:res.statusCode],
                                [response MIMEType]];
            
        }
        
    } else {
        
        errorDescription = [NSString stringWithFormat:@"%ld %@ - %@",
                            (long)res.statusCode,
                            [NSHTTPURLResponse localizedStringForStatusCode:res.statusCode],
                            [response MIMEType]];
        
    }
    
    return @{
             ERROR_TITLE : @"RequestFailed",
             @"description": [NSString stringWithFormat:@"%ld %@ - %@",
                              (long)res.statusCode,
                              [NSHTTPURLResponse localizedStringForStatusCode:res.statusCode],
                              [response MIMEType]],
             @"Data": data
             };
    
}
#pragma mark -
#pragma makr - Object Serialization
/*! NSURLResponse를 가지고 데이터 형태를 파악 후 object를 JSON형태의 데이터로 변환 해주는 메소드
 * \param response 서버의 응답 형태
 * \param data 서버에서 내려 받은 데이터
 * \returns JSON Object를 반환한다.
 */
- (id)objectForResponse:(NSURLResponse *)response data:(NSData *)data
{
    
    NSDictionary *errorInfo = [self validateResponse:(NSHTTPURLResponse *)response data:data];
    if (!errorInfo) {
        
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        if ([data length] > 0) {
            NSError *serializationError = nil;
            // NSJSONSerialization Option은 ALSerialization.rtf 파일 참고
            id resultObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
            
            if (serializationError) {
                errorInfo = @{
                              ERROR_TITLE : @"SerializationFailed",
                              @"description": [serializationError description],
                              @"Data": data
                              };
            }
            
            if (resultObject) {
                return resultObject;
            } else {
                errorInfo = @{ERROR_TITLE : @"SerializationFailed",
                              @"description": @"serialization data is nil" };
            }
            
        } else {
            errorInfo = @{ERROR_TITLE : @"SerializationFailed",
                          @"description": @"receive data is nil" };
        }
        
    }
    
    return errorInfo;
}


#pragma mark -
#pragma mark - Request Serialization
- (NSMutableURLRequest *)requestWithURL:(NSURL *)URL
                             httpMethod:(NSString *)method
                             parameters:(NSDictionary *)parameters
{
    
    NSParameterAssert(URL);
    NSParameterAssert(method);
    
    if (!parameters) {
        parameters = @{};
    }
    
    // 파라메터 수집
    NSMutableString *strParam = [[NSMutableString alloc] init];
    
    for (NSString *key in [parameters allKeys]) {
        
        if (strParam.length != 0) {
            [strParam appendFormat:@"&%@=%@", key, parameters[key]];
        } else {
            [strParam appendFormat:@"%@=%@",  key, parameters[key]];
        }
        
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    if ([method isEqualToString:@"GET"]) {

        // 앞에 ?를 붙여준다.
        if ([strParam length] != 0) {
            [strParam insertString:@"?" atIndex:0];
        }
        NSString *strEncodeParam = [strParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [request setURL:[NSURL URLWithString:strEncodeParam relativeToURL:URL]];
        [request setHTTPMethod:method];
        [request setURL:URL];
        NSLog(@"URL Check : %@", [NSURL URLWithString:strEncodeParam relativeToURL:URL]);
        
    } else if ([method isEqualToString:@"POST"] ||
               [method isEqualToString:@"PUT"] ||
               [method isEqualToString:@"DELETE"]) {
        
        [request setHTTPMethod:method];
        [request setURL:URL];
        
        NSString *strEncodeParam = [strParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *dataParam = [strEncodeParam dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:dataParam];
        
    }
    
    return request;
    
}

- (void)amszonS3Upload
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *contentMd5  = [request valueForHTTPHeaderField:@"Content-MD5"];
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    NSString *timestamp   = [request valueForHTTPHeaderField:@"Date"];
    
    if (nil == contentMd5)  contentMd5  = @"";
    if (nil == contentType) contentType = @"";
    
    NSMutableString *canonicalizedAmzHeaders = [NSMutableString string];
    
    NSArray *sortedHeaders = [[[request allHTTPHeaderFields] allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    for (id key in sortedHeaders)
    {
        NSString *keyName = [(NSString *)key lowercaseString];
        if ([keyName hasPrefix:@"x-amz-"]){
            [canonicalizedAmzHeaders appendFormat:@"%@:%@\n", keyName, [request valueForHTTPHeaderField:(NSString *)key]];
        }
    }
    
    NSString *bucket = @"";
    NSString *path   = request.URL.path;
    NSString *query  = request.URL.query;
    
    NSString *host  = [request valueForHTTPHeaderField:@"Host"];
    
    if (![host isEqualToString:@"s3.amazonaws.com"]) {
        bucket = [host substringToIndex:[host rangeOfString:@".s3.amazonaws.com"].location];
    }
    
    NSString* canonicalizedResource;
    
    if (nil == path || path.length < 1) {
        if ( nil == bucket || bucket.length < 1 ) {
            canonicalizedResource = @"/";
        }
        else {
            canonicalizedResource = [NSString stringWithFormat:@"/%@/", bucket];
        }
        
    }
    else {
        canonicalizedResource = [NSString stringWithFormat:@"/%@%@", bucket, path];
    }
    
    if (query != nil && [query length] > 0) {
        canonicalizedResource = [canonicalizedResource stringByAppendingFormat:@"?%@", query];
    }
    
    NSString* stringToSign = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", [request HTTPMethod], contentMd5, contentType, timestamp, canonicalizedAmzHeaders, canonicalizedResource];
    
//    NSString *signature = [self signatureForString:stringToSign];
//    
//    [request setValue:[NSString stringWithFormat:@"AWS %@:%@", self.S3AccessKey, signature] forHTTPHeaderField:@"Authorization"];
//    
//}
//
//- (NSURLSessionDataTask *)POSTDataToS3:(NSURL *)fromFile
//                                   Key:(NSString *)key
//                     completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
//{
//    S3PutObjectRequest *s3Request = [[S3PutObjectRequest alloc] initWithKey:key inBucket:_s3Bucket];
//    s3Request.cannedACL = [S3CannedACL publicReadWrite];
//    s3Request.securityToken = [CTUserDefaults awsS3SessionToken];
//    [s3Request configureURLRequest];
//    NSMutableURLRequest *request = [_s3Client signS3Request:s3Request];
//    // For some reason, the signed S3 request comes back with '(null)' as a host.
//    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", _s3Client.endpoint, _s3Bucket, [key stringWithURLEncoding]] ;
//    request.URL = [NSURL URLWithString:urlString];
//    // Have to create a new request and copy all the headers otherwise the NSURLSessionDataTask will fail (since request get a pointer back to AmazonURLRequest which is a subclass of NSMutableURLRequest)
//    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    [request2 setHTTPMethod:@"PUT"];
//    [request2 setAllHTTPHeaderFields:[request allHTTPHeaderFields]];
//    NSURLSessionDataTask *task = [self uploadTaskWithRequest:request2
//                                                    fromFile:fromFile
//                                                    progress:nil
//                                           completionHandler:completionHandler];
//    return task;
//}

/*
 else if ([method isEqualToString:@"multipart/form-data"]) {
 
 [request setHTTPMethod:@"POST"];
 [request setURL:URL];
 
 NSMutableData * body = [NSMutableData data];
 NSString *boundary = @"0xKhTmLbOuNdArY";
 NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
 [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
 
 for (NSString *key in [parameters allKeys]) {
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary]dataUsingEncoding:NSUTF8StringEncoding]];
 if ([[parameters[key] class] isSubclassOfClass:[NSString class]]) {
 [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithFormat:@"%@\r\n", parameters[key]] dataUsingEncoding:NSUTF8StringEncoding]];
 }
 else if([[parameters[key] class] isSubclassOfClass:[UIImage class]])
 {
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:
 [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", key, key] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:UIImageJPEGRepresentation(parameters[key], 1.0)];
 [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
 }
 else if([[parameters[key] class] isSubclassOfClass:[NSData class]])
 {
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:
 [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; \r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:parameters[key]];
 [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
 }
 
 }
 [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 
 [request setHTTPBody:body];
 }
 */

/* SBJson 같은 외부 Lib를 사용하고 싶다면?
 * 아래 코드를 추가하면 된다.
 
 Class serializer = nil;
 serializer = NSClassFromString(@"SBJsonParser");
 if (serializer) {
    id parser = [[serializer alloc] init];
    id object = [parser objectWithData:data];
    return object;
 }
 serializer = NSClassFromString(@"NSJSONSerialization");
 .... 여기부터는 아래 코드 추가 ...
 
 */

#pragma mark -
#pragma mark - JSONSerialization Method Implement
/*! JSONData를 Serialization하여 사용할 수 있는 Object를 만드는 메소드
 * \param data - JSON형태를 가지고 있는 data
 * \returns 새로운 오브젝트를 반환한다.
 */
+ (id)objectFromJSONData:(NSData *)data
{
    
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:kNilOptions
                                             error:&error];
}

/*! JSONString을 Serialization하여 사용할 수 있는 Object를 만드는 메소드
 * \param JSONString - JSON형태를 가지고 있는 Serialization된 String
 * \returns 새로운 오브젝트를 반환한다.
 */
+ (id)objectFromJSONString:(NSString *)JSONString
{
    return [[self class] objectFromJSONData:[JSONString dataUsingEncoding:NSUTF8StringEncoding]];
}


#pragma mark -
#pragma mark - Generate Method Implement
/*! object를 JSON형태의 데이터로 변환 해주는 메소드
 * \param object - JSON형태를 가지고 있는 object
 * \returns 새로운 NSData를 반환한다.
 */
+ (NSData *)dataFromJSONObject:(id)object
{
    NSError *error = nil;
    return [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
}

/*! object를 JSON형태의 데이터로 변환 해주는 메소드
 * \param object - JSON형태를 가지고 있는 object
 * \returns 새로운 NSString을 반환한다.
 */
+ (NSString *)stringFromObject:(id)object
{
    NSData *data = [[self class] dataFromJSONObject:object];
    NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return JSONString;
}

/*! object가 JSON형태인지 확인하는 메소드
 * \param object - JSON형태를 가지고 있는 object
 * \returns Object == JSON?.
 */
+ (BOOL)isValidJSONObject:(id)object
{
    return [NSJSONSerialization isValidJSONObject:object];
}

@end
