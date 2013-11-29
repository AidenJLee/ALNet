//
//  ALMainViewController.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 20..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALTransaction.h"
#import "UIAsyncImageView.h"

@interface ALMainViewController : UIViewController
{
    ALTransaction *_alt;
}

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIAsyncImageView *AsyncImageView;

@end
