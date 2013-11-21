//
//  ALSerialization.m
//  AIDENJLEENetworking
//
//  Created by HoJun Lee on 2013. 11. 12..
//  Copyright (c) 2013년 HoJun Lee. All rights reserved.
//

#import "ALSerialization.h"

@implementation ALSerialization

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.statusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        self.contentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    }
    
    return self;
}

#pragma mark -
- (id)objectForResponse:(NSURLResponse *)response data:(NSData *)data
{
    
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    if (![self.statusCodes containsIndex:(NSUInteger)res.statusCode] ||
        ![self.contentTypes containsObject:[res MIMEType]]) {
        if ([data length] > 0) {
            return nil;
        }
    }

    // NSJSONSerialization Issue : https://github.com/rails/rails/issues/1742
    NSStringEncoding stringEncoding = NSUTF8StringEncoding;
    if (response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
    if (responseString && ![responseString isEqualToString:@" "]) {
        // Workaround for a bug in NSJSONSerialization when Unicode character escape codes are used instead of the actual character
        // See http://stackoverflow.com/a/12843465/157142
        data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data) {
            if ([data length] > 0) {
                NSError *error = nil;
                return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            } else {
                return nil;
            }
        }
    }
    
    return nil;
}

/* SBJson Lib를 사용하고 싶다면?
 * 아래 코드를 추가하면 된다.
 
 Class serializer = nil;
 serializer = NSClassFromString(@"SBJsonParser");
 if (serializer) {
    id parser = [[serializer alloc] init];
    id object = [parser objectWithData:data];
    return object;
 }
 serializer = NSClassFromString(@"NSJSONSerialization");
 .... 아래 코드 ...
 
 */

#pragma mark -
#pragma mark - JSONSerialization Method Implement
/*! JSONData를 Serialization하여 사용할 수 있는 Object를 만드는 메소드
 * \param data - JSON형태를 가지고 있는 data
 * \returns 새로운 오브젝트를 반환한다.
 */
+ (id)objectFromJSONData:(NSData *)data
{
    
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:kNilOptions
                                             error:&error];
}

/*! JSONString을 Serialization하여 사용할 수 있는 Object를 만드는 메소드
 * \param JSONString - JSON형태를 가지고 있는 Serialization된 String
 * \returns 새로운 오브젝트를 반환한다.
 */
+ (id)objectFromJSONString:(NSString *)JSONString
{
    return [[self class] objectFromJSONData:[JSONString dataUsingEncoding:NSUTF8StringEncoding]];
}


#pragma mark -
#pragma mark - Generate Method Implement
/*! object를 JSON형태의 데이터로 변환 해주는 메소드
 * \param object - JSON형태를 가지고 있는 object
 * \returns 새로운 NSData를 반환한다.
 */
+ (NSData *)JSONDataFromJSONObject:(id)object
{
    NSError *error = nil;
    return [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
}

/*! object를 JSON형태의 데이터로 변환 해주는 메소드
 * \param object - JSON형태를 가지고 있는 object
 * \returns 새로운 NSString을 반환한다.
 */
+ (NSString *)JSONStringFromObject:(id)object
{
    NSData *data = [[self class] JSONDataFromJSONObject:object];
    NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return JSONString;
}

/*! object가 JSON형태인지 확인하는 메소드
 * \param object - JSON형태를 가지고 있는 object
 * \returns Object == JSON?.
 */
+ (BOOL)isValidJSONObject:(id)object
{
    return [NSJSONSerialization isValidJSONObject:object];
}

@end
