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

+ (CAAnimationGroup *)getAniGroupWithArr:(NSArray *)aniArr duration:(NSTimeInterval)duration repeat:(BOOL)isRepeat {
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.animations = aniArr;
    aniGroup.duration = duration;
    if (isRepeat) {
        aniGroup.repeatCount = MAXFLOAT;
    }
    aniGroup.removedOnCompletion = NO;
    aniGroup.fillMode = kCAFillModeForwards;
    return aniGroup;
    
}

@end
