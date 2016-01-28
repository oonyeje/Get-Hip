//
//  ParseNetDebug.h
//  GetHip
//
//  Created by Okechi on 1/6/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

#ifndef GetHip_ParseNetDebug_h
#define GetHip_ParseNetDebug_h
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseNetDebug : NSObject

+ (void)receiveWillSendURLRequestNotification:(NSNotification *) notification;


+ (void)receiveDidReceiveURLResponseNotification:(NSNotification *) notification;



@end

#endif
