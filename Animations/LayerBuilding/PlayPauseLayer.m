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


#define PauseSpringTPersent (8/31.0)
#define PauseNoSpringTPersent (1 - 8/31.0)

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
    //上下左右边中点位置
    CGPoint _upMidPoint, _downMidPoint, _leftMidPoint, _rightMidPoint;
    //四角位置
    CGPoint _leftUpPoint, _leftDownPoint, _rightUpPoint, _rightDownPoint;
    //三角形三顶点位置
    CGPoint _triangleUpPoint, _triangleDownPoint, _triangleRightPoint;
    //暂停端点位置 左
    CGPoint _pauseTopLeft, _pauseBottomLeft;
    CGPoint _pauseUpperMostLeft, _pauseDownMostLeft;
    //暂停端点位置 右
    CGPoint _pauseTopRight, _pauseBottomRight;
    CGPoint _pauseUpperMostRight, _pauseDownMostRight;
    
    CGPoint _pauseMidBottom, _pauseBezierControlLeft, _pauseBezierControlRight;
}

//PlayPause Button Animation Group
@property (nonatomic ,strong) CAAnimationGroup *circleAni, *triangleAni, *leftAni, *rightAni;
@property (nonatomic ,strong) CALayer *outterCircleLay, *innerTriangleLay, *pauseLeftLay, *pauseRightLay;

//UIBezierPath
@property (nonatomic, strong) UIBezierPath *outterCirclePath, *innerTrianglePath, *pauseLeftPath, *pauseRightPath;

@end

@implementation PlayPauseLayer

- (instancetype)init {
    self = [self initWithCenter:CGPointMake(10, 10)
                   buttonLength:20
                      lineWidth:4
                      lineColor:[UIColor blueColor]
                    aniDuration:0.8];
    return self;
}

- (instancetype)initWithCenter:(CGPoint)center buttonLength:(CGFloat)length lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor aniDuration:(NSTimeInterval)totalTime {
    if (self = [super init]) {
        [self playAndPauseWithCenter:center
                        buttonLength:length
                           lineWidth:lineWidth
                           lineColor:lineColor
                         aniDuration:totalTime];
    }
    return self;
}

- (void)playAndPauseWithCenter:(CGPoint)center buttonLength:(CGFloat)length lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor aniDuration:(NSTimeInterval)totalTime {
    [self buildPointsWithCenter:center borderLength:length];
    [self buildPaths];
    [self buildLayersWithStrokeWith:lineWidth StrokeColor:lineColor];
    [self buildAnimationsWithDuration:totalTime];
}

- (void)play {
    [self playAnimationNeedPause:YES];
}

- (void)pause {
    [self playAnimationNeedPause:NO];
}

- (void)playAnimationNeedPause:(BOOL)isNeedPause {
    if (isNeedPause) {
        self.outterCircleLay.hidden = NO;
        self.innerTriangleLay.hidden = NO;
        self.pauseLeftLay.hidden = YES;
        self.pauseRightLay.hidden = YES;
        [self.outterCircleLay addAnimation:self.circleAni forKey:@"groupAni"];
        [self.innerTriangleLay addAnimation:self.triangleAni forKey:@"groupAni"];
    } else {
        self.outterCircleLay.hidden = YES;
        self.innerTriangleLay.hidden = YES;
        self.pauseLeftLay.hidden = NO;
        self.pauseRightLay.hidden = NO;
        [self.pauseLeftLay addAnimation:self.leftAni forKey:@"groupAni"];
        [self.pauseRightLay addAnimation:self.rightAni forKey:@"groupAni"];
    }
}

#pragma mark - Points
- (void)buildPointsWithCenter:(CGPoint)center borderLength:(CGFloat)borderLength {
    if (borderLength <= 0) {
        NSAssert(NO, @"按钮长度不能设置为非正数");
    }
    
    CGFloat outterRadius = borderLength / 2.0;
    CGFloat innerRadius = outterRadius * InOutScale;
    CGFloat innerTriangleBorderLength = innerRadius * M_SQRT3;//三角形边长
    CGFloat undulateLength = innerTriangleBorderLength * undulatePersent;
    CGFloat triangleLeft = center.x - innerRadius/2;
    CGFloat pauseLeft = triangleLeft;
    CGFloat pauseRight = center.x + innerRadius/2;
    
    //三角形上、下、右边的顶点坐标
    _triangleUpPoint = CGPointMake(triangleLeft, center.y - innerTriangleBorderLength/2);
    _triangleDownPoint = CGPointMake(triangleLeft, center.y + innerTriangleBorderLength/2);
    _triangleRightPoint = CGPointMake(center.x + innerRadius, center.y);
    
    //外部圆形上、下、左、右的顶点坐标
    _upMidPoint = CGPointMake(center.x, center.y - outterRadius);
    _downMidPoint = CGPointMake(center.x, center.y + outterRadius);
    _leftMidPoint = CGPointMake(center.x - outterRadius, center.y);
    _rightMidPoint = CGPointMake(center.x + outterRadius, center.y);
    
    //按钮左上、左下、右上、右下的顶点
    _leftUpPoint = CGPointMake(center.x - outterRadius, center.y - outterRadius);
    _leftDownPoint = CGPointMake(center.x - outterRadius, center.y + outterRadius);
    _rightUpPoint = CGPointMake(center.x + outterRadius, center.y - outterRadius);
    _rightDownPoint = CGPointMake(center.x + outterRadius, center.y + outterRadius);
    
    //暂停弹簧最上、最下点纵坐标
    CGFloat pauseUpperMost = _triangleUpPoint.y - undulateLength;
    CGFloat pauseDownMost = _triangleDownPoint.y + undulateLength;
    
    //暂停按钮左边竖线坐标
    _pauseTopLeft = _triangleUpPoint;
    _pauseBottomLeft = _triangleDownPoint;
    _pauseUpperMostLeft = CGPointMake(pauseLeft, pauseUpperMost);
    _pauseDownMostLeft = CGPointMake(pauseLeft, pauseDownMost);
    
    //暂停按钮右边竖线坐标
    _pauseTopRight = CGPointMake(pauseRight, _triangleUpPoint.y);
    _pauseBottomRight = CGPointMake(pauseRight, _triangleDownPoint.y);
    _pauseUpperMostRight = CGPointMake(pauseRight, pauseUpperMost);
    _pauseDownMostRight = CGPointMake(pauseRight, pauseDownMost);
    
    
    _pauseMidBottom = CGPointMake(center.x, _triangleDownPoint.y + innerTriangleBorderLength * 0.2);
    _pauseBezierControlLeft = CGPointMake(_pauseTopLeft.x, _pauseMidBottom.y);
    _pauseBezierControlRight = CGPointMake(_pauseTopRight.x, _pauseMidBottom.y);
}

#pragma mark - Path
- (void)buildPaths {
    //外部圆形路径 转 左边竖线 播放→暂停状态
    [self.outterCirclePath moveToPoint:_rightMidPoint];
    [self.outterCirclePath addQuadCurveToPoint:_upMidPoint controlPoint:_rightUpPoint];
    [self.outterCirclePath addQuadCurveToPoint:_leftMidPoint controlPoint:_leftUpPoint];
    [self.outterCirclePath addQuadCurveToPoint:_downMidPoint controlPoint:_leftDownPoint];
    [self.outterCirclePath addQuadCurveToPoint:_rightMidPoint controlPoint:_rightDownPoint];
    [self.outterCirclePath addQuadCurveToPoint:_upMidPoint controlPoint:_rightUpPoint];
    [self.outterCirclePath addQuadCurveToPoint:_pauseTopLeft controlPoint:CGPointMake(_pauseTopLeft.x, _upMidPoint.y)];
    [self.outterCirclePath addLineToPoint:_pauseDownMostLeft];
    
    //内部三角形 转 右边竖线 播放→暂停状态
    [self.innerTrianglePath moveToPoint:_triangleDownPoint];
    [self.innerTrianglePath addLineToPoint:_triangleRightPoint];
    [self.innerTrianglePath addLineToPoint:_triangleUpPoint];
    [self.innerTrianglePath addLineToPoint:_triangleDownPoint];
    [self.innerTrianglePath addQuadCurveToPoint:_pauseMidBottom controlPoint:_pauseBezierControlLeft];
    [self.innerTrianglePath addQuadCurveToPoint:_pauseBottomRight controlPoint:_pauseBezierControlRight];
    [self.innerTrianglePath addLineToPoint:_pauseUpperMostRight];
    
    //左边竖线路径 转 三角形 暂停→播放状态
    [self.pauseLeftPath moveToPoint:_pauseUpperMostLeft];
    [self.pauseLeftPath addLineToPoint:_triangleDownPoint];
    [self.pauseLeftPath addLineToPoint:_triangleRightPoint];
    [self.pauseLeftPath addLineToPoint:_triangleUpPoint];
    [self.pauseLeftPath addLineToPoint:_triangleDownPoint];
    [self.pauseLeftPath addLineToPoint:_triangleRightPoint];
    
    //右边竖线路径 转 圆形 暂停→播放状态
    [self.pauseRightPath moveToPoint:_pauseDownMostRight];
    [self.pauseRightPath addLineToPoint:_pauseTopRight];
    [self.pauseRightPath addQuadCurveToPoint:_upMidPoint
                                controlPoint:CGPointMake(_pauseTopRight.x, _upMidPoint.y)];
    [self.pauseRightPath addQuadCurveToPoint:_leftMidPoint controlPoint:_leftUpPoint];
    [self.pauseRightPath addQuadCurveToPoint:_downMidPoint controlPoint:_leftDownPoint];
    [self.pauseRightPath addQuadCurveToPoint:_rightMidPoint controlPoint:_rightDownPoint];
    [self.pauseRightPath addQuadCurveToPoint:_upMidPoint controlPoint:_rightUpPoint];
}

#pragma mark - Layer
- (void)buildLayersWithStrokeWith:(CGFloat)lineWidth StrokeColor:(UIColor *)storkeColor {
    //播放按钮 外部圆形 layer
    self.outterCircleLay =
    [CAShapeLayer shapeLayerWithPath:self.outterCirclePath
                           lineWidth:lineWidth
                         strokeColor:storkeColor
                           fillColor:[UIColor clearColor]
                         strokeStart:0
                           strokeEnd:0.65];
    
    //播放按钮 内部三角形 layer
    self.innerTriangleLay =
    [CAShapeLayer shapeLayerWithPath:self.innerTrianglePath
                           lineWidth:lineWidth
                         strokeColor:storkeColor
                           fillColor:[UIColor clearColor]
                         strokeStart:0
                           strokeEnd:0.60];
    
    //暂停按钮 暂停→播放状态 左边竖线
    self.pauseLeftLay =
    [CAShapeLayer shapeLayerWithPath:self.pauseLeftPath
                           lineWidth:lineWidth
                         strokeColor:storkeColor
                           fillColor:[UIColor clearColor]
                         strokeStart:0
                           strokeEnd:CGFloatNULL];
    
    //暂停按钮 暂停→播放状态 右边竖线
    self.pauseRightLay =
    [CAShapeLayer shapeLayerWithPath:self.pauseRightPath
                           lineWidth:lineWidth
                         strokeColor:storkeColor
                           fillColor:[UIColor clearColor]
                         strokeStart:0.03
                           strokeEnd:0.143];
    
    [self addSublayer:self.outterCircleLay];
    [self addSublayer:self.innerTriangleLay];
    [self addSublayer:self.pauseLeftLay];
    [self addSublayer:self.pauseRightLay];
    self.pauseLeftLay.hidden = YES;
    self.pauseRightLay.hidden = YES;
}

#pragma mark - Animation
- (void)buildAnimationsWithDuration:(NSTimeInterval)totalTime {
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
    
    self.circleAni = [CAAnimation getAniGroupWithArr:@[ani_circle1, ani_circle2, ani_circle3, ani_circle4, ani_circle5, ani_circle6]
                                            duration:totalTime + 2
                                              repeat:NO];
    
    
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
    
    
    self.triangleAni = [CAAnimation getAniGroupWithArr:@[ani_triangle1, ani_triangle2, ani_triangle3, ani_triangle4, ani_triangle5]
                                              duration:totalTime + 2
                                                repeat:NO];
    
    //暂停按钮 左边竖线 暂停→播放状态 动画
    CABasicAnimation *ani_LV1 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0.03
                                    to:@0
                             beginTime:0
                              duration:totalTime * PauseSpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CABasicAnimation *ani_LV2 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@0.23
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
    
    self.leftAni = [CAAnimation getAniGroupWithArr:@[ani_LV1, ani_LV2, ani_LV3, ani_LV4]
                                          duration:totalTime + 2
                                            repeat:NO];
    
    
    //暂停按钮 右边竖线 暂停→播放状态 动画
    CABasicAnimation *ani_RV1 =
    [CAAnimation getBasicAniForKeypath:@"strokeStart"
                                  from:@0.02
                                    to:@0
                             beginTime:0
                              duration:totalTime * PauseSpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    CABasicAnimation *ani_RV2 =
    [CAAnimation getBasicAniForKeypath:@"strokeEnd"
                                  from:@0.14
                                    to:@0.12
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
                                  from:@0.12
                                    to:@1
                             beginTime:totalTime * PauseSpringTPersent
                              duration:totalTime * PauseNoSpringTPersent
                               reapeat:NO
                          timeFunction:nil];
    
    self.rightAni = [CAAnimation getAniGroupWithArr:@[ani_RV1, ani_RV2, ani_RV3, ani_RV4]
                                           duration:totalTime + 2
                                             repeat:NO];
}

#pragma mark - Getter
- (UIBezierPath *)outterCirclePath {
    if (!_outterCirclePath) {
        _outterCirclePath = [UIBezierPath bezierPath];
    }
    return _outterCirclePath;
}

- (UIBezierPath *)innerTrianglePath {
    if (!_innerTrianglePath) {
        _innerTrianglePath = [UIBezierPath bezierPath];
    }
    return _innerTrianglePath;
}

- (UIBezierPath *)pauseLeftPath {
    if (!_pauseLeftPath) {
        _pauseLeftPath = [UIBezierPath bezierPath];
    }
    return _pauseLeftPath;
}

- (UIBezierPath *)pauseRightPath {
    if (!_pauseRightPath) {
        _pauseRightPath = [UIBezierPath bezierPath];
    }
    return _pauseRightPath;
}

@end
