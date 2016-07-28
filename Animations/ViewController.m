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
    
    
    //构建播放按钮路径
    UIBezierPath *playPath = [UIBezierPath bezierPath];
    [playPath moveToPoint:triangleUpPoint];
    [playPath addLineToPoint:triangleDownPoint];
    [playPath addLineToPoint:triangleRightPoint];
    [playPath addLineToPoint:triangleUpPoint];
    [playPath addLineToPoint:triangleDownPoint];
    [playPath addLineToPoint:triangleRightPoint];
//    [playPath closePath];
    
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
    [self.view.layer addSublayer:triangleLayer];
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation1.fromValue = @0;
    animation1.toValue = @0.4;
    animation1.duration = 4;
    animation1.repeatCount = MAXFLOAT;
    
    
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation2.fromValue = @0.2;
    animation2.toValue = @1;
    animation2.duration = 4;
    animation2.repeatCount = MAXFLOAT;
    
//    [triangleLayer addAnimation:animation1 forKey:@"headAnimation"];
//    [triangleLayer addAnimation:animation2 forKey:@"Animation"];
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
