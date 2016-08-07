//
//  CAShapeLayer+SettingMethods.m
//  Animations
//
//  Created by Non on 16/8/7.
//  Copyright © 2016年 NonMac. All rights reserved.
//

#import "CAShapeLayer+SettingMethods.h"

@implementation CAShapeLayer (SettingMethods)

+ (CAShapeLayer *)shapeLayerWithPath:(UIBezierPath *)path lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor strokeStart:(CGFloat)start strokeEnd:(CGFloat)end {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = lineWidth;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.strokeColor = strokeColor.CGColor;
    layer.fillColor = fillColor.CGColor;
    if (start != CGFloatNULL) {
        layer.strokeStart = start;
    }
    if (end != CGFloatNULL) {
        layer.strokeEnd = end;
    }
    return layer;
}

@end
