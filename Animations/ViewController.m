//
//  ViewController.m
//  Animations
//
//  Created by NonMac on 7/28/16.
//  Copyright © 2016 NonMac. All rights reserved.
//

#define InOutScale (0.58)
#define M_SQRT3 sqrtf(3.0) //√3（根号3）
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

#import "ViewController.h"
#import "UIBezierPath+CalcLength.h"
#import "PlayPauseLayer.h"

/**
 *  @author NonMac, 16-07-31 20:07:42
 *
 *  播放 暂停按钮 比例
 * 三角 上下距离 高度1/2 上边40/160 35/160  右边 43/162
 * 暂停 左右分别 60/162
 *
 * 暂停 → 播放 （87 ~ 117）
 * 弹簧 87 ~ 90
 *
 * 播放 → 暂停
 * 25  9
 *
 *
 *
 *
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

//PlayPause Button Animation Group
@property (nonatomic ,strong) CAAnimationGroup *circleAni, *triangleAni, *leftAni, *rightAni;
@property (nonatomic ,strong) CALayer *circleLay, *triangleLay, *leftLay, *rightLay;


@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSArray *playToPause, *pauseToPlay;
@property (nonatomic, strong) CAAnimationGroup *ggggg;
@property (nonatomic, strong) UIColor *settedColor;

@property (nonatomic, strong) PlayPauseLayer *button;

@end

BOOL isNeedAddAnimation = NO;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.settedColor = [UIColor colorWithRed:0 green:216/255.0 blue:1 alpha:1];
    
    self.status = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeStatus)];
    [self.view addGestureRecognizer:tap];
    
    self.button = [[PlayPauseLayer alloc] initWithCenter:CGPointMake(200, 200)
                                            buttonLength:100
                                               lineWidth:8
                                               lineColor:self.settedColor
                                             aniDuration:0.4];
    [self.view.layer addSublayer:_button];
}

- (IBAction)sliderChanged:(UISlider *)sender {
    self.sliderNum.text = [NSString stringWithFormat:@"%f", sender.value];
    if (self.currentLayer) {
        self.currentLayer.strokeEnd = sender.value;
    }
}

- (void)changeStatus {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (self.status) {
        for (CALayer *layer in self.pauseToPlay) {
            layer.hidden = YES;
        }
        for (CALayer *layer in self.playToPause) {
            layer.hidden = NO;
        }
        [self.circleLay addAnimation:self.circleAni forKey:@"circle"];
        [self.triangleLay addAnimation:self.triangleAni forKey:@"tirangle"];
        
        [self.button pause];
        self.status = 0;
    } else {
        for (CALayer *layer in self.playToPause) {
            layer.hidden = YES;
        }
        for (CALayer *layer in self.pauseToPlay) {
            layer.hidden = NO;
        }
        [self.leftLay addAnimation:self.leftAni forKey:@"left"];
        [self.rightLay addAnimation:self.rightAni forKey:@"right"];
        
        [self.button play];
        self.status = 1;
    }
    [CATransaction commit];
}

@end
