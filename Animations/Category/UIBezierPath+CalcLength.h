//
//  UIBezierPath+CalcLength.h
//  Animations
//
//  Created by Non on 16/8/6.
//  Copyright © 2016年 NonMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (CalcLength)

@property (nonatomic, strong, readonly) NSNumber *currentLength;

- (double)len_addLineToPoint:(CGPoint)point;

@end
