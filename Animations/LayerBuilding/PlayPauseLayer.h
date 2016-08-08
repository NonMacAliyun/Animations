//
//  PlayPauseLayer.h
//  Animations
//
//  Created by Non on 16/8/7.
//  Copyright © 2016年 NonMac. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PlayPauseLayer : CALayer

- (instancetype)initWithCenter:(CGPoint)center buttonLength:(CGFloat)length lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor aniDuration:(NSTimeInterval)totalTime;
- (void)play;
- (void)pause;

@end
