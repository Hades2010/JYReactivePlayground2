//
//  JYDummySignInService.h
//  JYReactivePlayground
//
//  Created by JinYong on 15-1-9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^JYSignInResponse)(BOOL);
@interface JYDummySignInService : NSObject

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(JYSignInResponse)completeBlock;
@end
