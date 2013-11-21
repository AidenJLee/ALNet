//
//  UIAsyncImageView.h
//  AIDENJLEENetworking
//
//  Created by HoJun Lee on 2013. 11. 12..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALNetManager.h"
#import "ALCacheManager.h"

@interface UIAsyncImageView : UIImageView
{
    NSMutableArray *_arrRequestURLQueue;
    BOOL _hasAlphaAnimation;
}

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *bgViews;
@property (nonatomic, copy) NSURL *URLTag;


#pragma mark -
#pragma mark Public Method

- (void)setImageForURL:(NSURL *)URL;
- (void)setImageForOriginalURLString:(NSURL *)originalURL thumbnailURL:(NSURL *)thumbnailURL;


#pragma mak -
#pragma mark (for Framework) Public Method

- (void)setImageForReceivedURL:(NSURL *)URL;

@end
