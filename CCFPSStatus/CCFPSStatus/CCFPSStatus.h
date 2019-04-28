//
//  CCFPSStatus.h
//  CCFPSStatus
//
//  Created by dengyouhua on 2019/4/28 - now.
//  Copyright © 2019 cc | ccworld1000@gmail.com. All rights reserved.
//  https://github.com/ccworld1000/CCFPSStatus

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 show FPS status | Flexible location
 */
@interface CCFPSStatus : NSObject

+ (CCFPSStatus *)sharedInstance;

- (void)open;
- (void)openWithHandler:(void (^)(NSInteger fpsValue))handler;
- (void)close;

@end
