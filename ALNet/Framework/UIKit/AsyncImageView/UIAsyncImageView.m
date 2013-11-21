//
//  UIAsyncImageView.m
//  AIDENJLEENetworking
//
//  Created by HoJun Lee on 2013. 11. 12..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "UIAsyncImageView.h"

@implementation UIAsyncImageView


#pragma mark -
#pragma mark Property Method

- (void)setImage:(UIImage *)image
{
    
    BOOL isBGHidden = image ? YES : NO;
    
    for (UIView *viewBG in self.bgViews) {
        viewBG.hidden = isBGHidden;
    }
    
    [super setImage:image];
    
    if (image && _hasAlphaAnimation) {
        
        self.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1.0;
        }];
        
    } else {
        self.URLTag = nil;
    }
    
}


#pragma mark -
#pragma mark Private Method

- (void)setImage:(UIImage *)image URLTag:(NSURL *)urlTag
{
    
    if ([self.URLTag isEqual:urlTag]) {
        return;
    }
    
    self.URLTag = urlTag;
    [self setImage:image];
    
}


#pragma mark -
#pragma mark Public Method

- (void)setImageForURL:(NSURL *)URL
{
    
    UIImage *image = [[ALCacheManager sharedInstance] imageForURL:URL];
    
    if (image) {    // 캐쉬에 이미지가 존재함
        
        // 이전 request는 전부 무시한다.
        [_arrRequestURLQueue removeAllObjects];
        
        // alpha animation을 실행할 수 있도록 flag를 잡아준다.
        _hasAlphaAnimation = YES;
        [self setImage:image URLTag:URL];
        
    } else {    // 이미지가 존재 하지 않음 (요청 필요)
        
        // 초기화를 시킨다. (여기서 백그라운드의 Hidden이 풀려 백그라운드가 보이게 된다.)
        [self setImage:nil URLTag:nil];
        
        // 초기화를 위한 urlString이 들어온 경우는 request를 하지 않는다.
        if (!URL) {
            
            // 이전 request는 전무 무시한다.
            [_arrRequestURLQueue removeAllObjects];
            
            // 백그라운드는 숨긴다.
            for (UIView *viewBG in self.bgViews) {
                viewBG.hidden = YES;
            }
            
            return;
        }
        
        // 큐에 집어넣고 request를 날리고 receive를 기다린다.
        [_arrRequestURLQueue addObject:@{ @"url1" : URL }];
        
        // 요청
        id <ALNetManagerProtocol> _networkManager = [ALNetManager sharedInstance];
        
        NSMutableDictionary *requestInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
        requestInfo[@"common"]      = @{ @"url" : URL, @"type" : @"image", @"httpMethod" : @"get" };
        requestInfo[@"customParam"] = @{ @"imageView" : self };
        
        [_networkManager requestWithRequestInfo:requestInfo];
        
    }
    
}

- (void)setImageForOriginalURLString:(NSURL *)originalURL thumbnailURL:(NSURL *)thumbnailURL
{
    
    BOOL hasOriginalImageRequest  = NO;
    BOOL hasThumbnailImageRequest = NO;
    
    // 먼저 orignal image가 이미 있는지 본다.
    UIImage *image = [[ALCacheManager sharedInstance] imageForURL:originalURL];
    
    if (image) {
        
        // 이전 request는 전무 무시한다.
        [_arrRequestURLQueue removeAllObjects];
        
        // alpha animation을 실행할 수 있도록 flag를 잡아준다.
        _hasAlphaAnimation = YES;
        [self setImage:image URLTag:originalURL];
        
    } else {
        
        hasOriginalImageRequest = YES;
        
    }
    
    // tumbnail image가 이미 있는지 본다.
    image = [[ALCacheManager sharedInstance] imageForURL:thumbnailURL];
    
    if (image) {
        
        // 원본은 없다.
        if (hasOriginalImageRequest) {
            
            // 섬네일로 일단 올려준다.
            
            // alpha animation을 실행할 수 있도록 flag를 잡아준다.
            _hasAlphaAnimation = YES;
            [self setImage:image URLTag:thumbnailURL];
            
        }
        
    } else {
        
        hasThumbnailImageRequest = YES;
        
    }
    
    // 요청을 위한 network manager
    id <ALNetManagerProtocol> _networkManager = [ALNetManager sharedInstance];
    
    // original은 있는데 thumbnail이 없는 경우 thumbnail만 요청한다.
    if (!hasOriginalImageRequest && hasThumbnailImageRequest) {
        
        NSMutableDictionary *requestInfo = nil;
        requestInfo                 = [[NSMutableDictionary alloc] initWithCapacity:0];
        requestInfo[@"common"]      = @{ @"url" : thumbnailURL, @"type" : @"image", @"httpMethod" : @"get" };
        
        [_networkManager requestWithRequestInfo:requestInfo];
        
    } else if (hasOriginalImageRequest && hasThumbnailImageRequest) {   // original도 없고 thumnail도 없는 경우
        
        // 초기화를 시킨다.
        // 여기서 백그라운드의 Hidden이 풀려 백그라운드가 보이게 되며 나중에 receive된 image로 채워지게 된다.
        [self setImage:nil URLTag:nil];
        
        // 큐에 집어넣고 request를 날리고 receive를 기다린다.
        [_arrRequestURLQueue addObject:@{ @"url1" : originalURL, @"url2" : thumbnailURL }];
        
        // thumbnail 요청
        NSMutableDictionary *requestInfo = nil;
        
        requestInfo                 = [[NSMutableDictionary alloc] initWithCapacity:0];
        requestInfo[@"common"]      = @{ @"url" : thumbnailURL, @"type" : @"image", @"httpMethod" : @"get" };
        requestInfo[@"customParam"] = @{ @"imageView" : self };
        
        [_networkManager requestWithRequestInfo:requestInfo];
        
        // original 요청
        
        requestInfo                 = [[NSMutableDictionary alloc] initWithCapacity:0];
        requestInfo[@"common"]      = @{ @"url" : originalURL, @"type" : @"image", @"httpMethod" : @"get" };
        requestInfo[@"customParam"] = @{ @"imageView" : self };
        
        [_networkManager requestWithRequestInfo:requestInfo];
        
    } else if (hasOriginalImageRequest && !hasThumbnailImageRequest) {   // original만 없는 경우
        
        // 큐에 집어넣고 request를 날리고 receive를 기다린다.
        [_arrRequestURLQueue addObject:@{ @"url1" : originalURL, @"url2" : [NSURL URLWithString:@""] }];
        
        // original 요청
        NSMutableDictionary *requestInfo = nil;
        
        requestInfo                 = [[NSMutableDictionary alloc] initWithCapacity:0];
        requestInfo[@"common"]      = @{ @"url" : originalURL, @"type" : @"image", @"httpMethod" : @"get" };
        requestInfo[@"customParam"] = @{ @"imageView" : self };
        
        [_networkManager requestWithRequestInfo:requestInfo];
        
        
    }
    
}


#pragma mak -
#pragma mark (for Framework) Public Method

- (void)setImageForReceivedURL:(NSURL *)URL;
{
    
    if (_arrRequestURLQueue.count > 0) {
        
        NSURL *strURL1 = [_arrRequestURLQueue.lastObject[@"url1"] copy];
        NSURL *strURL2 = _arrRequestURLQueue.lastObject[@"url2"];
        
        // 마지막 요청과 다르다.
        if (!([strURL1 isEqual:URL] || [strURL2 isEqual:URL])) {
            
            
        } else if ([strURL2 isEqual:URL]) {   // thumbnail을 받았다.
            
            UIImage *image = [[ALCacheManager sharedInstance] imageForURL:URL];
            
            // alpha animation을 실행할 수 있도록 flag를 잡아준다.
            _hasAlphaAnimation = YES;
            [self setImage:image URLTag:URL];
            
            [_arrRequestURLQueue removeLastObject];
            [_arrRequestURLQueue addObject:@{ @"url1" : strURL1, @"url2" : [NSURL URLWithString:@""] }];  // 이미 thumbnail을 받았음을 알림.
            
        } else if ([strURL1 isEqual:URL] && [strURL2 isEqual:[NSURL URLWithString:@""]]) {   // original을 받았다.
            
            [_arrRequestURLQueue removeAllObjects];
            
            UIImage *image = [[ALCacheManager sharedInstance] imageForURL:URL];
            
            // alpha animation을 실행할 수 있도록 flag를 잡아준다.
            _hasAlphaAnimation = NO;
            [self setImage:image URLTag:URL];
            
        } else {
            
            UIImage *image = [[ALCacheManager sharedInstance] imageForURL:URL];
            
            // 이전 request는 전무 무시한다.
            [_arrRequestURLQueue removeAllObjects];
            
            // alpha animation을 실행할 수 있도록 flag를 잡아준다.
            _hasAlphaAnimation = YES;
            [self setImage:image URLTag:URL];
            
        }
        
    }
    
}


#pragma mark -
#pragma mark Init

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _arrRequestURLQueue = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _arrRequestURLQueue = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
    
}

@end
