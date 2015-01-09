//
//  JYDummySignInService.m
//  JYReactivePlayground
//
//  Created by JinYong on 15-1-9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "JYDummySignInService.h"

@implementation JYDummySignInService

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(JYSignInResponse)completeBlock{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        BOOL success = [username isEqualToString:@"user"] && [password isEqualToString:@"password"];
        completeBlock(success);
    });
}
@end
