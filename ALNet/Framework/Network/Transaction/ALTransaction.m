//
//  ALTransaction.m
//  AIDENJLEENetworking
//
//  Created by HoJun Lee on 2013. 11. 12..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALTransaction.h"

@implementation ALTransaction


#pragma mark -
#pragma mark Init
- (id)initWithTarget:(id)target successSelector:(SEL)selSuccess failureSelector:(SEL)selFailure
{
    
    self = [super init];
    if (self) {
        
        _target          = target;
        _successSeleltor = selSuccess;
        _failureSeleltor = selFailure;
        
        _observerKeys    = [[NSMutableArray alloc] initWithCapacity:5];
        
    }
    return self;
    
}

- (id)initWithUserInfo:(id)userInfo completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    return nil;
}

- (void)dealloc
{
    
    for (NSString *identifier in _observerKeys) {
        [self removeNotificationObserverForIdentifire:identifier];
    }
    [_observerKeys removeAllObjects];
    
}


#pragma mark -
#pragma mark Public Method (abstract)
- (void)sendRequestForUserInfo:(id)userInfo
{
    
}

// Callback By ALNetManager
- (void)didFinishReceive:(NSNotification *)noti
{
    
}


#pragma mark -
#pragma mark Public Method (for Framework)

- (void)addNotificationObserver
{
    NSString *strUniqueKey = [self observerKey];
    
    [_observerKeys addObject:strUniqueKey];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishReceive:)
                                                 name:strUniqueKey
                                               object:nil];
}

- (void)removeNotificationObserverForIdentifire:(NSString *)identifier
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:identifier object:nil];
}


#pragma mark -
#pragma mark ObserverKey Create Method Implement

- (NSString *)observerKey
{
    return [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate]];
}

//- (NSString *)uuid
//{
//    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
//    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
//    CFRelease(uuidRef);
//    return (__bridge NSString *)uuidStringRef;
//}

@end
