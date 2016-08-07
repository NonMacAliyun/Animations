//
//  CAAnimation+SettingMethods.m
//  Animations
//
//  Created by Non on 16/7/30.
//  Copyright © 2016年 NonMac. All rights reserved.
//

#import "CAAnimation+SettingMethods.h"

@implementation CAAnimation (SettingMethods)

+ (CABasicAnimation *)getBasicAniForKeypath:(NSString *)keypath
                                       from:(id)fromValue
                                         to:(id)toValue
                                   duration:(NSTimeInterval)duration
                                    reapeat:(BOOL)isRepeat
                               timeFunction:(NSString *)timeFunction {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:keypath];
    basicAnimation.fromValue = fromValue;
    basicAnimation.toValue = toValue;
    basicAnimation.duration = duration;
    if (isRepeat) {
        basicAnimation.repeatCount = MAXFLOAT;
    }
    if (timeFunction) {
        basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:timeFunction];
    }
//    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    return basicAnimation;
}

+ (CABasicAnimation *)getBasicAniForKeypath:(NSString *)keypath
                                       from:(id)fromValue
                                         to:(id)toValue
                                  beginTime:(NSTimeInterval)beginTime
                                   duration:(NSTimeInterval)duration
                                    reapeat:(BOOL)isRepeat
                               timeFunction:(NSString *)timeFunction {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:keypath];
    basicAnimation.fromValue = fromValue;
    basicAnimation.toValue = toValue;
    basicAnimation.beginTime = beginTime;
    basicAnimation.duration = duration;
    if (isRepeat) {
        basicAnimation.repeatCount = MAXFLOAT;
    }
    if (timeFunction) {
        basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:timeFunction];
    }
    //    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    return basicAnimation;
    
}

@end
