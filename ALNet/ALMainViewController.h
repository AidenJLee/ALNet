//
//  ALMainViewController.h
//  ALNet
//
//  Created by HoJun Lee on 2013. 11. 20..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALTransaction.h"

@interface ALMainViewController : UIViewController
{
    ALTransaction *_alt;
}

@property (strong, nonatomic) NSString *URLString;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
