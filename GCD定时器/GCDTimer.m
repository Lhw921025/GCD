//
//  GCDTimer.m
//  GCD定时器
//
//  Created by 刘红伟 on 2019/4/9.
//  Copyright © 2019 刘红伟. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer ()

@property (nonatomic, strong) NSMutableDictionary *timerArry;

@end

@implementation GCDTimer

+ (GCDTimer *)sharedInstance{
    static GCDTimer *GCDTimerManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        GCDTimerManager = [[GCDTimer alloc] init];
    });
    
    return GCDTimerManager;
}
- (void)scheduleGCDTimerWithInterval:(double)interval
                         repeatCount:(NSInteger)repeatCount
                         event:(dispatch_block_t)block
{
    if (interval <= 0) {
        return;
    }
    if (repeatCount <= 0)
    {
        return;
    }
    //用于确认一个Objective-C方法的有效性
    NSParameterAssert(block);
    
    //__block的作用告诉编译器,编译时在block内部不要把外部变量当做常量使用,还是要当做变量使用.
    __block NSInteger count = repeatCount;

    //dispatch_get_global_queue获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    //DISPATCH_SOURCE_TYPE_TIMER表示定时器
    dispatch_source_t dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //开启
    dispatch_resume(dispatchSource);
    
    //dispatch_walltime设定的时间段是绝对的，与设备是否running无关
    dispatch_time_t start = dispatch_walltime(NULL, (int64_t)(0.0 * NSEC_PER_SEC));
    
    //NSEC_PER_SEC表示的是秒数
    uint64_t time = (uint64_t)(interval * NSEC_PER_SEC);
    
    dispatch_source_set_timer(dispatchSource, start, time, 0);
    
    //时间间隔到点时执行block
    dispatch_source_set_event_handler(dispatchSource, ^{
        count -= 1;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
        
        if (count == 0) {
            dispatch_source_cancel(dispatchSource);
        }
    });
}
- (void)scheduleGCDTimerWithName:(NSString *)timerName
                        Interval:(double)interval
                           event:(dispatch_block_t)block
{
    if ([timerName isEqual:[NSNull null]]) {
        return;
    }
    if (timerName == nil || timerName == NULL) {
        return;
    }
    if ([[timerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return;
    }
    if (interval <= 0) {
        return;
    }
    NSParameterAssert(block);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    // 创建dispatch_source_t的timer
    dispatch_source_t timer = [self.timerArry objectForKey:timerName];
    
    if (nil == timer)
    {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerArry setObject:timer forKey:timerName];
    }
    
    dispatch_time_t start = dispatch_walltime(NULL, (int64_t)(0.0 * NSEC_PER_SEC));
    
    uint64_t time = (uint64_t)(interval * NSEC_PER_SEC);
    
    dispatch_source_set_timer(timer, start, time, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    });
    
}
- (void)scheduleGCDTimerAfterWithInterval:(double)interval
                                    event:(dispatch_block_t)block
{
    /*
    指定时间追加处理到dispatch_queue
    */
    dispatch_time_t start = dispatch_walltime(NULL, (int64_t)(interval * NSEC_PER_SEC));
    dispatch_after(start, dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}
// 取消timer
- (void)cancelTimerWithName:(NSString *)timerName
{
    dispatch_source_t timer = [self.timerArry objectForKey:timerName];
    
    if (!timer)
        return;
    
    [self.timerArry removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
}
#pragma mark - getter & setter
- (NSMutableDictionary *)timerArry
{
    if (!_timerArry) {
        _timerArry = [[NSMutableDictionary alloc] init];
    }
    return _timerArry;
}

@end
