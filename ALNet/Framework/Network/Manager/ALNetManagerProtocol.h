//
//  ALNetManagerProtocol.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 18..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ALNetManagerProtocol <NSObject>

@required
- (void)requestWithRequestInfo:(NSDictionary *)requestInfo;

@end
