//
//  ALHTTPSessionManagerProtocol.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 19..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ALHTTPSessionManagerProtocol <NSObject>

@required
- (id)initWithConfig:(NSURLSessionConfiguration *)configuration
              Target:(id)target
            selector:(SEL)selector
         requestInfo:(NSDictionary *)requestInfo;

@end
