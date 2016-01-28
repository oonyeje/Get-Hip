//
//  ParseNetDebug.m
//  GetHip
//
//  Created by Okechi on 1/7/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

#import "ParseNetDebug.h"

@implementation ParseNetDebug: NSObject
+ (void)receiveWillSendURLRequestNotification:(NSNotification *) notification {
    NSURLRequest *request = notification.userInfo[PFNetworkNotificationURLRequestUserInfoKey];
    NSLog(@"URL : %@", request.URL.absoluteString);
    NSLog(@"Method : %@", request.HTTPMethod);
    NSLog(@"Headers : %@", request.allHTTPHeaderFields);
    NSLog(@"Request Body : %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
}

+ (void)receiveDidReceiveURLResponseNotification:(NSNotification *) notification {
    NSURLRequest *request = notification.userInfo[PFNetworkNotificationURLRequestUserInfoKey];
    NSHTTPURLResponse *response = notification.userInfo[PFNetworkNotificationURLResponseUserInfoKey];
    NSString *responseBody = notification.userInfo[PFNetworkNotificationURLResponseBodyUserInfoKey];
    NSLog(@"URL : %@", request.URL.absoluteString);
    NSLog(@"Status Code : %ld", (long)response.statusCode);
    NSLog(@"Headers : %@", response.allHeaderFields);
    NSLog(@"Response Body : %@", responseBody);
}
@end
