//
//  PlayPauseLayer.m
//  Animations
//
//  Created by Non on 16/8/7.
//  Copyright © 2016年 NonMac. All rights reserved.
//

#import "PlayPauseLayer.h"

#define InOutScale (0.58)
#define undulatePersent (2/11.0)


#define PauseSpringTPersent (4/31.0)
#define PauseNoSpringTPersent (1 - 4/31.0)

//时间点
#define PlayTriangleSS1TStart (9/33.0)//内部三角形StrokeStart开始点1
#define PlayTriangleSS2TStart (14/33.0)//内部三角形StrokeStart开始点2
#define PlayTriangleSETStart (12/33.0)//内部三角形StrokeEnd开始点
#define PlayCircleSpeedUpTStart (12/33.0)//外部圆形加速开始点
#define PlaySpringTStart (24/33.0) //弹簧开始时间点

//时间段
#define PlayCircleSlowPersent (11/33.0) //外部圆形慢速时间
#define PlayCircleFastPersent (13/33.0) //外部圆形快速时间
#define PlayTriangleHeadST1Persent (5/33.0)//三角形StrokeStart动画时间
#define PlayTriangleHeadST2Persent (10/33.0)//三角形StrokeStart动画时间
#define PlayTriangleTailPersent (12/33.0)//三角形StrokeEnd动画时间

#define PlaySpringTPersent (9/33.0) //弹簧时段
#define PlayNoSpringTPersent (1 - 9/33.0)  //非弹簧时段

@interface PlayPauseLayer () {
    CGPoint _triangleUpPoint, _triangleDownPoint, _triangleRightPoint;
}

//PlayPause Button Animation Group
@property (nonatomic ,strong) CAAnimationGroup *circleAni, *triangleAni, *leftAni, *rightAni;
@property (nonatomic ,strong) CALayer *circleLay, *triangleLay, *leftLay, *rightLay;


@end

@implementation PlayPauseLayer

- (void)buildPointsWithCenter:(CGPoint)center borderLength:(CGFloat)borderLength {
    CGFloat outterRadius = borderLength / 2.0;
    CGFloat innerRadius = outterRadius * InOutScale;
    CGFloat innerTriangleBorderLength = innerRadius * M_SQRT3;//三角形边长
    CGFloat undulateLength = innerTriangleBorderLength * undulatePersent;
    
    //三角形上、下、右边的顶点坐标
    _triangleUpPoint = CGPointMake(center.x - innerRadius/2, center.y - innerTriangleBorderLength/2);
    _triangleDownPoint = CGPointMake(center.x - innerRadius/2, center.y + innerTriangleBorderLength/2);
    _triangleRightPoint = CGPointMake(center.x + innerRadius, center.y);
    
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
    
    //暂停弹簧最上、最下点纵坐标
    CGFloat pauseUpperMost = self.triangleUpPoint.y - undulateLength;
    CGFloat pauseDownMost = self.triangleDownPoint.y + undulateLength;
    
    //暂停按钮左边竖线坐标
    CGPoint leftVLineUp = CGPointMake(_triangleUpPoint.x, pauseUpperMost);
    
    //暂停按钮右边竖线坐标
    CGPoint rightVLineUp = CGPointMake(center.x * 2 - _triangleUpPoint.x, _triangleUpPoint.y);
    CGPoint rightVLineDowm = CGPointMake(center.x * 2 - _triangleDownPoint.x, pauseDownMost);
    
}


- (void)playAndPauseWithCenter:(CGPoint)center buttonLength:(CGFloat)length lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor aniDuration:(NSTimeInterval)totalTime {
    
    CGFloat outterRadius = length / 2.0;
    CGFloat innerRadius = outterRadius * InOutScale;
    CGFloat innerTriangleBorderLength = innerRadius * M_SQRT3;//三角形边长
    CGFloat undulateLength = innerTriangleBorderLength * undulatePersent;
    
    //三角形上、下、右边的顶点坐标
    self.triangleUpPoint = CGPointMake(center.x - innerRadius/2, center.y - innerTriangleBorderLength/2);
    self.triangleDownPoint = CGPointMake(center.x - innerRadius/2, center.y + innerTriangleBorderLength/2);
    self.triangleRightPoint = CGPointMake(center.x + innerRadius, center.y);
    
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
    
    //暂停弹簧最上、最下点纵坐标
    CGFloat pauseUpperMost = _triangleUpPoint.y - undulateLength;
    CGFloat pauseDownMost = _triangleDownPoint.y + undulateLength;
    
    //暂停按钮左边竖线坐标
    CGPoint leftVLineUp = CGPointMake(_triangleUpPoint.x, pauseUpperMost);
    
    //暂停按钮右边竖线坐标
    CGPoint rightVLineUp = CGPointMake(center.x * 2 - _triangleUpPoint.x, _triangleUpPoint.y);
    CGPoint rightVLineDowm = CGPointMake(center.x * 2 - _triangleDownPoint.x, pauseDownMost);
    
    
#pragma mark - Path
    //外部圆形路径 转 左边竖线 播放→暂停状态
    UIBezierPath *outterCirclePath = [UIBezierPath bezierPath];
    [outterCirclePath moveToPoint:circleRightPoint];
    [outterCirclePath addQuadCurveToPoint:circleUpPoint controlPoint:btnRightUp];
    [outterCirclePath addQuadCurveToPoint:circleLeftPoint controlPoint:btnLeftUp];
    [outterCirclePath addQuadCurveToPoint:circleDownPoint controlPoint:btnLeftDown];
    [outterCirclePath addQuadCurveToPoint:circleRightPoint controlPoint:btnRightDown];
    [outterCirclePath addQuadCurveToPoint:circleUpPoint controlPoint:btnRightUp];
    [outterCirclePath addQuadCurveToPoint:_triangleUpPoint controlPoint:CGPointMake(_triangleUpPoint.x, circleUpPoint.y)];
    [outterCirclePath addLineToPoint:CGPointMake(_triangleDownPoint.x, pauseDownMost)];
    
    //内部三角形 转 右边竖线 播放→暂停状态
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:_triangleDownPoint];
    [trianglePath addLineToPoint:_triangleRightPoint];
    [trianglePath addLineToPoint:_triangleUpPoint];
    [trianglePath addLineToPoint:_triangleDownPoint];
    [trianglePath addQuadCurveToPoint:CGPointMake(center.x, _triangleDownPoint.y + 10)
                         controlPoint:CGPointMake(_triangleDownPoint.x + 2, _triangleDownPoint.y + 10)];
    [trianglePath addQuadCurveToPoint:CGPointMake(rightVLineDowm.x, _triangleDownPoint.y)
                         controlPoint:CGPointMake(rightVLineDowm.x - 2, _triangleDownPoint.y + 10)];
    [trianglePath addLineToPoint:CGPointMake(rightVLineUp.x, pauseUpperMost)];
    
    
    //左边竖线路径 转 三角形 暂停→播放状态
    UIBezierPath *pauseLeftPath = [UIBezierPath bezierPath];
    [pauseLeftPath moveToPoint:leftVLineUp];
    [pauseLeftPath addLineToPoint:_triangleDownPoint];
    [pauseLeftPath addLineToPoint:_triangleRightPoint];
    [pauseLeftPath addLineToPoint:_triangleUpPoint];
    [pauseLeftPath addLineToPoint:_triangleDownPoint];
    [pauseLeftPath addLineToPoint:_triangleRightPoint];
    
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
                                                   strokeColor:lineColor
                                                     fillColor:[UIColor clearColor]
                                                   strokeStart:0
                                                     strokeEnd:0.65];
    self.circleLay = outterCircleLayer;
    
    
    //播放按钮 内部三角形 layer
    CAShapeLayer *innerTriangle =
    [self shapeLayerWithPath:trianglePath
                   lineWidth:lineWidth
                 strokeColor:lineColor
                   fillColor:[UIColor clearColor]
                 strokeStart:0
                   strokeEnd:0.60];
    self.triangleLay = innerTriangle;
    
    
    //暂停按钮 暂停→播放状态 左边竖线
    CAShapeLayer *pauseLeftLayer = [self shapeLayerWithPath:pauseLeftPath
                                                  lineWidth:lineWidth
                                                strokeColor:lineColor
                                                  fillColor:[UIColor clearColor]
                                                strokeStart:0
                                                  strokeEnd:CGFloatNULL];
    self.leftLay = pauseLeftLayer;
    
    //暂停按钮 暂停→播放状态 右边竖线
    CAShapeLayer *pauseRightLayer = [self shapeLayerWithPath:pauseRightPath
                                                   lineWidth:lineWidth
                                                 strokeColor:lineColor
                                                   fillColor:[UIColor clearColor]
                                                 strokeStart:0.03
                                                   strokeEnd:0.143];
    self.rightLay = pauseRightLayer;
    
    [self addSublayer:outterCircleLayer];
    [self addSublayer:innerTriangle];
    [self addSublayer:pauseLeftLayer];
    [self addSublayer:pauseRightLayer];
    
    self.currentLayer = pauseRightLayer;
    self.playToPause = @[outterCircleLayer, innerTriangle];
    self.pauseToPlay = @[pauseLeftLayer, pauseRightLayer];
    
    
#pragma mark - Animation
    //播放按钮 内部三角形 播放→暂停状态 动画 开始：第9帧 共25帧
    CAAnimation *ani_triangle1 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@0.6
                                    to:@1
                             beginTime:totalTime * PlayTriangleSETStart
                              duration:totalTime * PlayTriangleTailPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CAAnimation *ani_triangle2 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0
                                    to:@0.45
                             beginTime:totalTime * PlayTriangleSS1TStart
                              duration:totalTime * PlayTriangleHeadST1Persent
                               reapeat:NO
                          timeFunction:nil];
    
    CAAnimation *ani_triangle3 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0.45
                                    to:@0.79
                             beginTime:totalTime * PlayTriangleSS2TStart
                              duration:totalTime * PlayTriangleHeadST2Persent
                               reapeat:NO
                          timeFunction:nil];
    
    CAAnimation *ani_triangle4 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@1
                                    to:@0.965
                             beginTime:totalTime * PlaySpringTStart
                              duration:totalTime * PlaySpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CAAnimation *ani_triangle5 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0.79
                                    to:@0.76
                             beginTime:totalTime * PlaySpringTStart
                              duration:totalTime * PlaySpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    
    CAAnimationGroup *triangleAniGroup = [CAAnimation getAniGroupWithArr:@[ani_triangle1, ani_triangle2, ani_triangle3, ani_triangle4, ani_triangle5]
                                                                duration:totalTime + 2
                                                                  repeat:NO];
    self.triangleAni = triangleAniGroup;
    [innerTriangle addAnimation:triangleAniGroup forKey:@"group"];
    
    
    //播放按钮 外部圆形 播放→暂停状态 动画
    CABasicAnimation *ani_circle1 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0
                                    to:@0.6
                             beginTime:0
                              duration:totalTime * PlayCircleSlowPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CABasicAnimation *ani_circle2 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@0.65
                                    to:@0.75
                             beginTime:0
                              duration:totalTime * PlayCircleSlowPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CABasicAnimation *ani_circle3 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0.6
                                    to:@0.895
                             beginTime:totalTime * PlayCircleSlowPersent
                              duration:totalTime * PlayCircleFastPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CABasicAnimation *ani_circle4 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@0.75
                                    to:@1
                             beginTime:totalTime * PlayCircleSlowPersent
                              duration:totalTime * PlayCircleFastPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CABasicAnimation *ani_circle5 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0.895
                                    to:@0.88
                             beginTime:totalTime * PlaySpringTStart
                              duration:totalTime * PlaySpringTPersent
                               reapeat:NO
                          timeFunction:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *ani_circle6 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@1
                                    to:@0.982
                             beginTime:totalTime * PlaySpringTStart
                              duration:totalTime * PlaySpringTPersent
                               reapeat:NO
                          timeFunction:kCAMediaTimingFunctionEaseOut];
    
    CAAnimation *ani_circle7 =
    [CAAnimation getBasicAniForKeypath:@"hidden"
                                  from:@NO
                                    to:@YES
                             beginTime:0
                              duration:0.1
                               reapeat:NO
                          timeFunction:nil];
    
    CAAnimationGroup *aniGroup_circle = [CAAnimation getAniGroupWithArr:@[ani_circle1, ani_circle2, ani_circle3, ani_circle4, ani_circle5, ani_circle6]
                                                               duration:totalTime + 2
                                                                 repeat:NO];
    self.circleAni = aniGroup_circle;
    [outterCircleLayer addAnimation:aniGroup_circle forKey:@"aniGroup_circle"];
    
    
    //暂停按钮 左边竖线 暂停→播放状态 动画
    CABasicAnimation *ani_LV1 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0.02
                                    to:@0
                             beginTime:0
                              duration:totalTime * PauseSpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CABasicAnimation *ani_LV2 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@0.21
                                    to:@0.2
                             beginTime:0
                              duration:totalTime * PauseSpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CABasicAnimation *ani_LV3 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0
                                    to:@0.4
                             beginTime:totalTime * PauseSpringTPersent
                              duration:totalTime * PauseNoSpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CABasicAnimation *ani_LV4 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@0.2
                                    to:@1
                             beginTime:totalTime * PauseSpringTPersent
                              duration:totalTime * PauseNoSpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CAAnimation *ani_LV5 =
    [CAAnimation getBasicAniForKeypath:@"hidden"
                                  from:@NO
                                    to:@YES
                             beginTime:totalTime
                              duration:0.1
                               reapeat:NO
                          timeFunction:nil];
    
    CAAnimationGroup *pauseLeftAniGroup = [CAAnimation getAniGroupWithArr:@[ani_LV1, ani_LV2, ani_LV3, ani_LV4]
                                                                 duration:totalTime + 2
                                                                   repeat:NO];
    self.leftAni = pauseLeftAniGroup;
    [pauseLeftLayer addAnimation:pauseLeftAniGroup forKey:@"pauseLeftAniGroup"];
    
    
    
    
    //暂停按钮 右边竖线 暂停→播放状态 动画
    CABasicAnimation *ani_RV1 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0.03
                                    to:@0
                             beginTime:0
                              duration:totalTime * PauseSpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CABasicAnimation *ani_RV2 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@0.13
                                    to:@0.1
                             beginTime:0
                              duration:totalTime * PauseSpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CABasicAnimation *ani_RV3 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0
                                    to:@0.2
                             beginTime:totalTime * PauseSpringTPersent
                              duration:totalTime * (8/31.0)
                               reapeat:NO
                          timeFunction:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *ani_RV4 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@0.1
                                    to:@1
                             beginTime:totalTime * PauseSpringTPersent
                              duration:totalTime * PauseNoSpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CAAnimationGroup *pauseRightAniGroup = [CAAnimation getAniGroupWithArr:@[ani_RV1, ani_RV2,  ani_RV3,  ani_RV4]
                                                                  duration:totalTime + 2
                                                                    repeat:NO];
    self.rightAni = pauseRightAniGroup;
    [pauseRightLayer addAnimation:pauseRightAniGroup forKey:@"pauseRightAniGroup"];
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

@end
