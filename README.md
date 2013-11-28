ALNet
=====

## Introduction

This is a Network Framework for iOS URL Loading System.

## Usage

A simple example of sending Request.

#### first. imort ALTransaction and declared instance

###### ViewController.h file

    #import "ALTransaction.h"
    @interface SomethingViewController : UIViewController
    {
      ALTransaction *_alt;
    }


#### second. init instance and make a Seletors

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

#### last. use ALTransaction with UserInfo

    - (IBAction)sendDataTaskForGET:(id)sender
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


## Bugs / Feature Requests

Think you’ve found a bug? 

Please open a case in issue page.


## Contributors

..... nil 
T_T

## tnahk to

[@CHKMATE](https://github.com/CHKMATE)  
[@Keigun](https://github.com/Keigun)  

and

Mentor
[@dotNetTree](https://github.com/dotNetTree)  


## License

Read a Lincense file.



### References
[iOS URL Loading System](https://developer.apple.com/library/ios/DOCUMENTATION/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.pdf)  
[What is REST? - from Wikipedia](http://en.wikipedia.org/wiki/Representational_state_transfer)  
[What is Comet - from Wikipedia](http://en.wikipedia.org/wiki/Comet_%28programming%29)  
[RFC 2616 - Hypertext Transfer Protocol — HTTP/1.1](http://tools.ietf.org/html/rfc2616)  

