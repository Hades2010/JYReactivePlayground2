//
//  UncaughtExceptionHandler.h
//  JYReactivePlayground
//
//  Created by JinYong on 15-2-11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject<UIAlertViewDelegate>{
    BOOL dismissed;
}
void HandleException(NSException *exception);
void SignalHandler(int signal);

void InstallUncaughtExceptionHandler(void);

@end
