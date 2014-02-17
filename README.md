ALNet
=====
## Introduction

This is a Network Framework for iOS URL Loading System.


## Usage

A simple example of sending Request.

#### FIRST,  
imort ALTransaction and declared instance

###### ViewController.h file

    #import "ALTransaction.h"
    @interface SomethingViewController : UIViewController
    {
      ALTransaction *_alt;
    }


#### SECOND,  
init instance and make a Seletors

###### Viewcontroller.m file

    - (id)initWithCoder:(NSCoder *)aDecoder
    {
      self = [super initWithCoder:aDecoder];
      if (self) {
          _alt = [[ALTransaction alloc] initWithTarget:self
                                       successSelector:@selector(recieveSuccess:)
                                       failureSelector:@selector(recieveFailure:)];
      }
      return self;
    }
    - (void)recieveSuccess:(id)result
    {
    }
    - (void)recieveFailure:(id)result
    {
    }

#### LAST,  
use ALTransaction with UserInfo

    - (IBAction)sendSomethingAction:(id)sender
    {
      [_alt sendRequestForUserInfo:@{ @"url": @"http://www.example.com/v1/something/URL" }];
    }


#### that`s it!



## Detail Info

how to user other HTTPMethod?

    [_alt sendRequestForUserInfo:@{
                                        @"url"        : @"http://www.example.com/v1/something/URL",
                                        @"httpMethod" : @"post",
                                        @"param"      : @{ @"_id": @"528d25bf8055296c3a000001" }
                                     }];

More info - /Framework/Network/UserInfo.plist 


## Todo

+ ResponseSerialization Bug fix (may be...CR, LF Peoblem.)
+ Various Network supported in ALTransaction (HTTP, TCP/IP)
+ Progressive UI
+ Background Download
+ Background Upload for Amazon S3


## Bugs / Feature Requests

Think you’ve found a bug? 

Please open a case in issue page.


## Thanks to

@SarahJoo  
[@CHKMATE](https://github.com/CHKMATE)  
[@Keigun](https://github.com/Keigun)  

[@dotNetTree](https://github.com/dotNetTree) (Mentor)  



## License

GNU GPL V2 - Read a Lincense file.


## References
[iOS URL Loading System](https://developer.apple.com/library/ios/DOCUMENTATION/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.pdf)  
[What is REST? - from Wikipedia](http://en.wikipedia.org/wiki/Representational_state_transfer)  
[What is Comet - from Wikipedia](http://en.wikipedia.org/wiki/Comet_%28programming%29)  
[RFC 2616 - Hypertext Transfer Protocol — HTTP/1.1](http://tools.ietf.org/html/rfc2616)  

