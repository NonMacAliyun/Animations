//
//  ViewController.m
//  Animations
//
//  Created by NonMac on 7/28/16.
//  Copyright © 2016 NonMac. All rights reserved.
//

#define InOutScale (0.58)
#define M_SQRT3 sqrtf(3.0) //√3（根号3）
#define CGFloatNULL -1

#import "ViewController.h"

/**
 *  @author NonMac, 16-07-31 20:07:42
 *
 *  播放 暂停按钮 比例
 * 三角 上下距离 高度1/2 上边40/160 35/160  右边 43/162
 * 暂停 左右分别 60/162
 */

@interface ViewController ()
//IBAction
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *sliderNum;
@property (nonatomic, strong) CAShapeLayer *currentLayer;


@property (nonatomic, strong) UIBezierPath *squarePath;

//PlayPause Button Path
//播放→暂停（外部圆、内部三角）
@property (nonatomic, strong) UIBezierPath *circlePath, *trianglePath;
//暂停→播放（左、右两个竖线）
@property (nonatomic, strong) UIBezierPath *leftVLine, *rightVLine;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self playAndPauseWithCenter:CGPointMake(200, 200) buttonLength:100 lineWidth:10];
}

- (void)playAndPauseWithCenter:(CGPoint)center buttonLength:(CGFloat)length lineWidth:(CGFloat)lineWidth {
    double totalTime = 1.3;
    
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
    
    //暂停按钮右边竖线坐标
    CGPoint rightVLineUp = CGPointMake(center.x * 2 - triangleUpPoint.x, triangleUpPoint.y - 5);
    CGPoint rightVLineDowm = CGPointMake(center.x * 2 - triangleDownPoint.x, triangleDownPoint.y);
    
#pragma mark - Path
    //外部圆形路径 转 左边竖线 播放→暂停状态
    UIBezierPath *outterCirclePath = [UIBezierPath bezierPath];
    [outterCirclePath moveToPoint:circleRightPoint];
    [outterCirclePath addQuadCurveToPoint:circleUpPoint controlPoint:btnRightUp];
    [outterCirclePath addQuadCurveToPoint:circleLeftPoint controlPoint:btnLeftUp];
    [outterCirclePath addQuadCurveToPoint:circleDownPoint controlPoint:btnLeftDown];
    [outterCirclePath addQuadCurveToPoint:circleRightPoint controlPoint:btnRightDown];
    [outterCirclePath addQuadCurveToPoint:circleUpPoint controlPoint:btnRightUp];
    [outterCirclePath addQuadCurveToPoint:triangleUpPoint controlPoint:CGPointMake(triangleUpPoint.x, circleUpPoint.y)];
    [outterCirclePath addLineToPoint:triangleDownPoint];
    
    //内部三角形 转 右边竖线 播放→暂停状态
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:triangleDownPoint];
    [trianglePath addLineToPoint:triangleRightPoint];
    [trianglePath addLineToPoint:triangleUpPoint];
    [trianglePath addLineToPoint:triangleDownPoint];
    [trianglePath addQuadCurveToPoint:CGPointMake(center.x, triangleDownPoint.y + 10)
                             controlPoint:CGPointMake(triangleDownPoint.x + 2, triangleDownPoint.y + 10)];
    [trianglePath addQuadCurveToPoint:rightVLineDowm
                             controlPoint:CGPointMake(rightVLineDowm.x - 2, rightVLineDowm.y + 10)];
    [trianglePath addLineToPoint:rightVLineUp];
    
    
    //左边竖线路径 转 三角形 暂停→播放状态
    UIBezierPath *pauseLeftPath = [UIBezierPath bezierPath];
    [pauseLeftPath moveToPoint:triangleUpPoint];
    [pauseLeftPath addLineToPoint:triangleDownPoint];
    [pauseLeftPath addLineToPoint:triangleRightPoint];
    [pauseLeftPath addLineToPoint:triangleUpPoint];
    [pauseLeftPath addLineToPoint:triangleDownPoint];
    [pauseLeftPath addLineToPoint:triangleRightPoint];
    
    //右边竖线路径 转 圆形 暂停→播放状态
    UIBezierPath *pauseRightPath = [UIBezierPath bezierPath];
    [pauseRightPath moveToPoint:rightVLineDowm];
    [pauseRightPath addLineToPoint:rightVLineUp];
    [pauseRightPath addQuadCurveToPoint:circleUpPoint
                     controlPoint:CGPointMake(rightVLineUp.x, circleUpPoint.y)];
    [pauseRightPath addQuadCurveToPoint:circleLeftPoint controlPoint:btnLeftUp];
    [pauseRightPath addQuadCurveToPoint:circleDownPoint controlPoint:btnLeftDown];
    [pauseRightPath addQuadCurveToPoint:circleRightPoint controlPoint:btnRightDown];
    [pauseRightPath addQuadCurveToPoint:circleUpPoint controlPoint:btnRightUp];
    
    
#pragma mark - Layer
    //播放按钮 外部圆形 layer
    CAShapeLayer *outterCircleLayer = [self shapeLayerWithPath:outterCirclePath
                                                     lineWidth:lineWidth
                                                   strokeColor:[UIColor cyanColor]
                                                     fillColor:[UIColor clearColor]
                                                   strokeStart:0
                                                     strokeEnd:0.65];
//    [self.view.layer addSublayer:outterCircleLayer];
    
    
    //播放按钮 内部三角形 layer
    CAShapeLayer *innerTriangle =
    [self shapeLayerWithPath:trianglePath
                   lineWidth:lineWidth
                 strokeColor:[UIColor cyanColor]
                   fillColor:[UIColor clearColor]
                 strokeStart:0
                   strokeEnd:0.62];
//    [self.view.layer addSublayer:innerTriangle];
    
    
    //暂停按钮 暂停→播放状态 左边竖线
    CAShapeLayer *pauseLeftLayer = [self shapeLayerWithPath:pauseLeftPath
                                               lineWidth:lineWidth
                                             strokeColor:[UIColor purpleColor]
                                               fillColor:[UIColor clearColor]
                                             strokeStart:0
                                               strokeEnd:CGFloatNULL];//0.2];
    [self.view.layer addSublayer:pauseLeftLayer];
    
    //暂停按钮 暂停→播放状态 右边竖线
    CAShapeLayer *pauseRightLayer = [self shapeLayerWithPath:pauseRightPath
                                               lineWidth:lineWidth
                                             strokeColor:[UIColor purpleColor]
                                               fillColor:[UIColor clearColor]
                                             strokeStart:0
                                               strokeEnd:0.143];//0.2];
    [self.view.layer addSublayer:pauseRightLayer];
    self.currentLayer = pauseRightLayer;
    
    
#pragma mark - Animation
    //播放按钮 内部三角形 播放→暂停状态 动画
    CAAnimation *ani_triangle1 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@0.62
                                    to:@1
                              duration:totalTime - 0.5
                               reapeat:NO
                          timeFunction:kCAMediaTimingFunctionDefault];
    
    CAAnimation *ani_triangle2 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0
                                    to:@0.79
                              duration:totalTime - 0.5
                               reapeat:NO
                          timeFunction:kCAMediaTimingFunctionDefault];
    
    CAAnimation *ani_triangle3 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@1
                                    to:@0.975
                              duration:0.5
                               reapeat:NO
                          timeFunction:kCAMediaTimingFunctionDefault];
    ani_triangle3.beginTime = totalTime - 0.5;
    
    CAAnimation *ani_triangle4 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0.79
                                    to:@0.766
                              duration:0.5
                               reapeat:NO
                          timeFunction:kCAMediaTimingFunctionDefault];
    ani_triangle4.beginTime = totalTime - 0.5;
    
    
    CAAnimationGroup *agroup = [self getAniGroupWithArr:@[ani_triangle1, ani_triangle2, ani_triangle3, ani_triangle4]
                                               duration:totalTime + 2
                                                 repeat:YES];
    [innerTriangle addAnimation:agroup forKey:@"group"];
    
    
    //播放按钮 外部圆形 播放→暂停状态 动画
    CABasicAnimation *ani_circle1 = [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                                                  from:@0
                                                                    to:@0.65
                                                              duration:totalTime - 0.24 / (0.35/totalTime)
                                                               reapeat:NO
                                                          timeFunction:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *ani_circle2 = [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                                                  from:@0.65
                                                                    to:@0.895
                                                              duration:0.24 / (0.35/totalTime)
                                                               reapeat:NO
                                                          timeFunction:kCAMediaTimingFunctionEaseOut];
    ani_circle2.beginTime = totalTime - 0.24 / (0.35/totalTime);
    
    CABasicAnimation *ani_circle3 = [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                                                  from:@0.65
                                                                    to:@1
                                                              duration:totalTime
                                                               reapeat:NO
                                                          timeFunction:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *aniGroup_circle = [self getAniGroupWithArr:@[ani_circle1, ani_circle2, ani_circle3]
                                                        duration:totalTime + 2
                                                          repeat:YES];
    [outterCircleLayer addAnimation:aniGroup_circle forKey:@"group"];
    
    
    //暂停按钮 左边竖线 暂停→播放状态 动画
    CABasicAnimation *ani_LV1 = [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                                                from:@0
                                                                  to:@0.4
                                                            duration:1
                                                             reapeat:NO
                                                        timeFunction:nil];
    
    CABasicAnimation *ani_LV2 = [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                                                 from:@0.2
                                                                   to:@1
                                                             duration:1
                                                              reapeat:NO
                                                         timeFunction:nil];
    
    CABasicAnimation *ani_LV3 = [CAAnimation getBasicAniForKeypath:@"transform.rotation.x"
                                                                 from:@0
                                                                   to:@M_PI
                                                             duration:5
                                                              reapeat:NO
                                                         timeFunction:nil];
    
    
    [pauseLeftLayer addAnimation:ani_LV1 forKey:@"headAnimation"];
    [pauseLeftLayer addAnimation:ani_LV2 forKey:@"Animation"];
//    [pauseLeftLayer addAnimation:ani_LV3 forKey:@"AnimationRotation"];
    
    
    
    
    //暂停按钮 右边竖线 暂停→播放状态 动画
    CABasicAnimation *ani_RV1 = [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                                              from:@0
                                                                to:@0.2
                                                          duration:1
                                                           reapeat:NO
                                                      timeFunction:nil];
    
    CABasicAnimation *ani_RV2 = [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                                              from:@0.143
                                                                to:@1
                                                          duration:1
                                                           reapeat:NO
                                                      timeFunction:nil];
    
//    CABasicAnimation *ani_RV3 = [CAAnimation getBasicAniForKeypath:@"transform.rotation.x"
//                                                              from:@0
//                                                                to:@M_PI
//                                                          duration:5
//                                                           reapeat:NO
//                                                      timeFunction:nil];
    CAAnimationGroup *aniGroup = [self getAniGroupWithArr:@[ani_RV1, ani_RV2]
                                                 duration:totalTime + 2
                                                   repeat:YES];
    [pauseRightLayer addAnimation:aniGroup forKey:@"werwer"];
}

- (CAShapeLayer *)shapeLayerWithPath:(UIBezierPath *)path lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor strokeStart:(CGFloat)start strokeEnd:(CGFloat)end {
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

- (void)setBasicAnimation:(CABasicAnimation *)animation from:(id)fromValue to:(id)toValue duration:(CFTimeInterval)duration timingFunction:(NSString *)timingFunction {
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
}

- (CAAnimationGroup *)getAniGroupWithArr:(NSArray *)aniArr duration:(NSTimeInterval)duration repeat:(BOOL)isRepeat {
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.animations = aniArr;
    aniGroup.duration = duration;
    if (isRepeat) {
        aniGroup.repeatCount = MAXFLOAT;
    }
    aniGroup.fillMode = kCAFillModeForwards;
    return aniGroup;
    
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
//    [self.view.layer addSublayer:layer];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.path = self.squarePath.CGPath;
    layer2.lineWidth = 5;
    layer2.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5].CGColor;
    layer2.fillColor = [UIColor clearColor].CGColor;
//    [self.view.layer addSublayer:layer2];
    
    
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

- (IBAction)sliderChanged:(UISlider *)sender {
    self.sliderNum.text = [NSString stringWithFormat:@"%f", sender.value];
    if (self.currentLayer) {
        self.currentLayer.strokeEnd = sender.value;
    }
}

@end
