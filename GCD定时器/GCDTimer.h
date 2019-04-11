//
//  GCDTimer.h
//  GCD定时器
//
//  Created by 刘红伟 on 2019/4/9.
//  Copyright © 2019 刘红伟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDTimer : NSObject

+ (GCDTimer *)sharedInstance;

// GCD定时器倒计时⏳
//   - interval: 循环间隔时间
//   - repeatCount: 重复次数
- (void)scheduleGCDTimerWithInterval:(double)interval
                         repeatCount:(NSInteger)repeatCount
                               event:(dispatch_block_t)block;
// - name:定时器名字
// - interval: 循环间隔时间
// 此方法在使用时，记得在页面消失时取消定时器
- (void)scheduleGCDTimerWithName:(NSString *)timerName
                        Interval:(double)interval
                           event:(dispatch_block_t)block;
//   - interval: 延时时间
- (void)scheduleGCDTimerAfterWithInterval:(double)interval
                                    event:(dispatch_block_t)block;
// 取消timer
- (void)cancelTimerWithName:(NSString *)timerName;
@end

NS_ASSUME_NONNULL_END
