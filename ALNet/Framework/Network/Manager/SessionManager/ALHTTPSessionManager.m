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
- (instancetype)initWithTarget:(id)target
                      selector:(SEL)selector
                 configuration:(NSURLSessionConfiguration *)configuration
{
    
    self = [super initWithTarget:target selector:selector configuration:configuration];
    if (self) {
        _serialization = [[ALSerialization alloc] init];
	}
	return self;
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ Description: %p, session: %@, operationQueue: %@", NSStringFromClass([self class]), self, self.session, self.session.delegateQueue];
}


#pragma mark -
#pragma mark - HTTP Public Method Implement
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(NSURLSessionDataTask *task, id responseObject))completionHandler
{
    
    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"GET" URLString:URLString parameters:parameters];
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        if (completionHandler) {
            id value = [self.serialization objectForResponse:response data:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            completionHandler(task, value);
        }
    }];
    [task resume];
    
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(NSURLSessionDataTask *task, id responseObject))completionHandler
{
    
//    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"POST" URLString:URLString parameters:parameters];
//    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error) {
//
//        }
//        if (completionHandler) {
//            id value = [self.serialization objectForResponse:response data:data];
//            if (value) {
//                self.requestInfo[@"value"] = value;
//            } else {
//                self.requestInfo[@"value"] = @{};
//            }
//            completionHandler(task, self.requestInfo);
//        }
//    }];
//    [task resume];
    
}

- (void)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(NSURLSessionDataTask *task, id responseObject))completionHandler
{
//    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"POST" URLString:URLString parameters:parameters];
//    NSMutableData  *md = [[ NSMutableData  alloc] initWithLength : 1000000]; // 1e6
//    __block NSURLSessionUploadTask *uploadTask = [self.session uploadTaskWithRequest:request fromData:md completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (completionHandler) {
//            self.requestInfo[@"value"] = [self.serialization objectForResponse:response data:data];
//            completionHandler(uploadTask, self.requestInfo);
//        }
//    }];
//    [uploadTask resume];
    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"PUT" URLString:URLString parameters:parameters];
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        if (completionHandler) {
            completionHandler(task, [self.serialization objectForResponse:response data:data]);
        }
    }];
    [task resume];
}

- (void)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(NSURLSessionDataTask *task, id responseObject))completionHandler
{
    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"DELETE" URLString:URLString parameters:parameters];
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        if (completionHandler) {
            completionHandler(task, [self.serialization objectForResponse:response data:data]);
        }
    }];
    [task resume];
}

- (void)somethingWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLSessionDataTask *task, id responseObject))completionHandler
{
//    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error) {
//            
//        }
//        if (completionHandler) {
//            id value = [self.serialization objectForResponse:response data:data];
//            if (value) {
//                self.requestInfo[@"value"] = value;
//            } else {
//                self.requestInfo[@"value"] = @{};
//            }
//            
//            completionHandler(task, self.requestInfo);
//        }
//    }];
//    [task resume];
}

- (void)GET:(NSURL *)URL parameters:(NSDictionary *)parameters
{
    
    if ([[URL path] length] > 0 && ![[URL absoluteString] hasSuffix:@"/"]) {
        URL = [URL URLByAppendingPathComponent:@""];
    }
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
        }
        [self.serialization objectForResponse:response data:data];
//        [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
    }];
    [task resume];
    
}

- (void)POST:(NSURL *)URL parameters:(NSDictionary *)parameters
{
    
    if ([[URL path] length] > 0 && ![[URL absoluteString] hasSuffix:@"/"]) {
        URL = [URL URLByAppendingPathComponent:@""];
    }
    
//    NSMutableURLRequest *request = [self.serialization req:self.requestInfo];
//    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error) {
//            
//        }
//        [self serializationWithResponse:response receivedData:data];
//        [_target performSelectorOnMainThread:_selector withObject:self.requestInfo waitUntilDone:NO];
//    }];
//    [task resume];
    
}

@end
