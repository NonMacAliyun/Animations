//
//  ViewController.m
//  Animations
//
//  Created by NonMac on 7/28/16.
//  Copyright © 2016 NonMac. All rights reserved.
//

#define InOutScale (0.58)
#define M_SQRT3 sqrtf(3.0) //√3（根号3）
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIBezierPath *squarePath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self palyAndPauseWithCenter:CGPointMake(200, 200) buttonLength:100 lineWidth:10];
}

- (void)palyAndPauseWithCenter:(CGPoint)center buttonLength:(CGFloat)length lineWidth:(CGFloat)lineWidth {
    CGFloat outterRadius = length / 2.0;
    CGFloat innerRadius = outterRadius * InOutScale;
    CGFloat innerTriangleBorderLength = innerRadius * M_SQRT3;//三角形边长
    
    //三角形上、下、右边的顶点坐标
    CGPoint triangleUpPoint = CGPointMake(center.x - innerRadius/2, center.y - innerTriangleBorderLength/2);
    CGPoint triangleDownPoint = CGPointMake(center.x - innerRadius/2, center.y + innerTriangleBorderLength/2);
    CGPoint triangleRightPoint = CGPointMake(center.x + innerRadius, center.y);
    
    //外部圆形上、下、左、右的顶点坐标
    CGPoint circleUpPoint = CGPointMake(center.x, center.y - outterRadius);
    CGPoint circleDownPoint = CGPointMake(center.x, center.y + outterRadius);
    CGPoint circleLeftPoint = CGPointMake(center.x - outterRadius, center.y);
    CGPoint circleRightPoint = CGPointMake(center.x + outterRadius, center.y);
    
    //按钮左上、左下、右上、右下的顶点
    CGPoint btnLeftUp = CGPointMake(center.x - outterRadius, center.y - outterRadius);
    CGPoint btnLeftDown = CGPointMake(center.x - outterRadius, center.y + outterRadius);
    CGPoint btnRightUp = CGPointMake(center.x + outterRadius, center.y - outterRadius);
    CGPoint btnRightDown = CGPointMake(center.x + outterRadius, center.y + outterRadius);
    
    
    //构建播放按钮路径
    UIBezierPath *playPath = [UIBezierPath bezierPath];
    [playPath moveToPoint:triangleUpPoint];
    [playPath addLineToPoint:triangleDownPoint];
    [playPath addLineToPoint:triangleRightPoint];
    [playPath addLineToPoint:triangleUpPoint];
    [playPath addLineToPoint:triangleDownPoint];
    [playPath addLineToPoint:triangleRightPoint];
    
    
    //外部圆形路径1 播放→暂停
    UIBezierPath *leftVerticalPath = [UIBezierPath bezierPath];
    [leftVerticalPath moveToPoint:circleRightPoint];
    [leftVerticalPath addQuadCurveToPoint:circleUpPoint controlPoint:btnRightUp];
    [leftVerticalPath addQuadCurveToPoint:circleLeftPoint controlPoint:btnLeftUp];
    [leftVerticalPath addQuadCurveToPoint:circleDownPoint controlPoint:btnLeftDown];
    [leftVerticalPath addQuadCurveToPoint:circleRightPoint controlPoint:btnRightDown];
    [leftVerticalPath addQuadCurveToPoint:circleUpPoint controlPoint:btnRightUp];
    [leftVerticalPath addQuadCurveToPoint:triangleUpPoint controlPoint:CGPointMake(triangleUpPoint.x, circleUpPoint.y)];
    [leftVerticalPath addLineToPoint:triangleDownPoint];
    
    
    //设置三角形layer
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    triangleLayer.path = playPath.CGPath;
    triangleLayer.lineWidth = lineWidth;
    triangleLayer.lineCap = kCALineCapRound;
    triangleLayer.lineJoin = kCALineJoinRound;
    triangleLayer.strokeColor = [UIColor cyanColor].CGColor;
    triangleLayer.fillColor = [UIColor clearColor].CGColor;
    
    triangleLayer.strokeStart = 0;
    triangleLayer.strokeEnd = 0.2;
//    [self.view.layer addSublayer:triangleLayer];
    
    
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation1.fromValue = @0;
    animation1.toValue = @0.4;
    animation1.duration = 1;
    animation1.repeatCount = MAXFLOAT;
    
    
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation2.fromValue = @0.2;
    animation2.toValue = @1;
    animation2.duration = 1;
    animation2.repeatCount = MAXFLOAT;
    
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    animation3.fromValue = @0;
    animation3.toValue = @M_PI;
    animation3.duration = 5;
    animation3.repeatCount = MAXFLOAT;
    
    
//    [triangleLayer addAnimation:animation1 forKey:@"headAnimation"];
//    [triangleLayer addAnimation:animation2 forKey:@"Animation"];
//    [triangleLayer addAnimation:animation3 forKey:@"AnimationRotation"];
    
    
    
    CAShapeLayer *pauseLeftVertical = [CAShapeLayer layer];
    pauseLeftVertical.path = leftVerticalPath.CGPath;
    pauseLeftVertical.lineCap = kCALineCapRound;
    pauseLeftVertical.lineJoin = kCALineJoinRound;
    pauseLeftVertical.lineWidth = lineWidth;
    pauseLeftVertical.strokeColor = [UIColor cyanColor].CGColor;
    pauseLeftVertical.fillColor = [UIColor clearColor].CGColor;
    pauseLeftVertical.strokeStart = 0;
    pauseLeftVertical.strokeEnd = 0.65;
    [self.view.layer addSublayer:pauseLeftVertical];
    
    CABasicAnimation *animation4 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation4.fromValue = @0;
    animation4.toValue = @0.89;
    animation4.duration = 4;
    animation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation4.repeatCount = MAXFLOAT;
    animation4.repeatDuration = 5;
    
    CABasicAnimation *animation5 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation5.fromValue = @0.65;
    animation5.toValue = @1;
    animation5.duration = 4;
//    animation5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation5.repeatCount = MAXFLOAT;
    
    [pauseLeftVertical addAnimation:animation4 forKey:@"headAnimation"];
    [pauseLeftVertical addAnimation:animation5 forKey:@"Animation"];
}

- (void)dialogFrame {
    self.squarePath = [UIBezierPath bezierPath];
    [self.squarePath moveToPoint:CGPointMake(250, 30)];
    [self.squarePath addLineToPoint:CGPointMake(240, 35)];
    [self.squarePath addLineToPoint:CGPointMake(170, 35)];
    [self.squarePath addLineToPoint:CGPointMake(170, 135)];
    [self.squarePath addLineToPoint:CGPointMake(310, 135)];
    [self.squarePath addLineToPoint:CGPointMake(310, 35)];
    [self.squarePath addLineToPoint:CGPointMake(260, 35)];
    [self.squarePath closePath];
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = self.squarePath.CGPath;
    layer.lineWidth = 5;
    layer.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.path = self.squarePath.CGPath;
    layer2.lineWidth = 5;
    layer2.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5].CGColor;
    layer2.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:layer2];
    
    
    CFTimeInterval date = [[NSDate date] timeIntervalSince1970];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.beginTime = CACurrentMediaTime() + 1;
    animation.duration = 6;
    animation.keyPath = @"strokeStart";
    animation.fromValue = @0.01;
    animation.toValue = @1;
    [layer addAnimation:animation forKey:@"headAnimation"];
    
    CABasicAnimation *animation1 = [CABasicAnimation animation];
    animation1.beginTime = CACurrentMediaTime();
    animation1.duration = 1;
    animation1.keyPath = @"hidden";
    animation1.fromValue = @NO;
    animation1.toValue = @YES;
    [layer2 addAnimation:animation1 forKey:@"hiddenn"];
    
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.beginTime = CACurrentMediaTime() + 1.3;
    animation2.duration = 6;
    animation2.keyPath = @"strokeEnd";
    animation2.fromValue = @0.01;
    animation2.toValue = @1;
    [layer2 addAnimation:animation2 forKey:@"head2Animation"];
}

@end
