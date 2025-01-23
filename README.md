# ALNet

## Introduction
ALNet is a network framework designed for the iOS URL Loading System.

## Usage
Here's a simple example of sending a request.

### FIRST,
Import `ALTransaction` and declare an instance.

**ViewController.h**

```objc
#import "ALTransaction.h"

@interface SomethingViewController : UIViewController
{
  ALTransaction *_alt;
}
```

### SECOND,
Initialize the instance and define the selectors.

**ViewController.m**

```objc
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
```

### LAST,
Use `ALTransaction` with user information.

```objc
- (IBAction)sendSomethingAction:(id)sender
{
  [_alt sendRequestForUserInfo:@{ @"url": @"http://www.example.com/v1/something/URL" }];
}
```

That's it!

## Detailed Info

### How to use other HTTP methods?

To use other HTTP methods, pass the desired method as part of the `userInfo` dictionary.

```objc
[_alt sendRequestForUserInfo:@{
                                    @"url"        : @"http://www.example.com/v1/something/URL",
                                    @"httpMethod" : @"POST",
                                    @"param"      : @{ @"_id": @"528d25bf8055296c3a000001" }
                                 }];
```

For more information, see `/Framework/Network/UserInfo.plist`.

## Todo

- Fix ResponseSerialization bug (potential CR, LF issue).
- Support for various network protocols in ALTransaction (HTTP, TCP/IP).
- Implement Progressive UI.
- Background download and upload (for Amazon S3).

## Bugs / Feature Requests
If you think you've found a bug, please open an issue on the GitHub issues page.

## Thanks to
- @SarahJoo
- @CHKMATE
- @Keigun
- @dotNetTree (Mentor)

## License
This project is licensed under the GNU GPL v2. See the LICENSE file for details.

## References
- [iOS URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system)
- [What is REST?](https://en.wikipedia.org/wiki/Representational_state_transfer) - Wikipedia
- [What is Comet?](https://en.wikipedia.org/wiki/Comet_(programming)) - Wikipedia
- [RFC 2616 - Hypertext Transfer Protocol — HTTP/1.1](https://tools.ietf.org/html/rfc2616)

  
