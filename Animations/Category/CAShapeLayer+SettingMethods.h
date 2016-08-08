//
//  CAShapeLayer+SettingMethods.h
//  Animations
//
//  Created by Non on 16/8/7.
//  Copyright © 2016年 NonMac. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAShapeLayer (SettingMethods)

+ (CAShapeLayer *)shapeLayerWithPath:(UIBezierPath *)path lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor strokeStart:(CGFloat)start strokeEnd:(CGFloat)end;

@end
