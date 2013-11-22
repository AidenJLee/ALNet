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

#pragma mark -
#pragma mark - HTTP Public Method Implement
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler
{
    
    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"GET" URLString:URLString parameters:parameters];
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        if (completionHandler) {
            NSError *error = nil;
            id result = [self.serialization objectForResponse:response data:data];
            if (error) {
                NSLog(@"Serialization Error : %@", [error description]);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(result);
            });
        }
    }];
    [self addObserverForTask:task];
    [task resume];
    
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler
{
    
    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"POST" URLString:URLString parameters:parameters];
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler([self.serialization objectForResponse:response data:data]);
            });
        }
    }];
    [self addObserverForTask:task];
    [task resume];
    
}

- (void)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler
{
    
    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"PUT" URLString:URLString parameters:parameters];
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler([self.serialization objectForResponse:response data:data]);
            });
        }
    }];
    [self addObserverForTask:task];
    [task resume];
    
}

- (void)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObject))completionHandler
{
    
    NSMutableURLRequest *request = [self.serialization requestWithMethod:@"DELETE" URLString:URLString parameters:parameters];
    __block NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            
        }
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler([self.serialization objectForResponse:response data:data]);
            });
        }
    }];
    [self addObserverForTask:task];
    [task resume];
    
}


@end
