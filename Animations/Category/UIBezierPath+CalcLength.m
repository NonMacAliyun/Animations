//
//  UIBezierPath+CalcLength.m
//  Animations
//
//  Created by Non on 16/8/6.
//  Copyright © 2016年 NonMac. All rights reserved.
//

#import "UIBezierPath+CalcLength.h"
#import <objc/runtime.h>

static char *currentLengthKey = "currentLengthKey";

@implementation UIBezierPath (CalcLength)

- (NSNumber *)currentLength {
    NSNumber *length = objc_getAssociatedObject(self, currentLengthKey);
    if (!length) {
        length = [NSNumber numberWithDouble:0.0];
        self.currentLength = length;
    }
    return length;
}

- (void)setCurrentLength:(NSNumber *)currentLength {
    objc_setAssociatedObject(self, currentLengthKey, currentLength, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

double length = 0.0;
- (double)len_addLineToPoint:(CGPoint)point {
    [self addLineToPoint:point];
    length += 1.2;
    self.currentLength = [NSNumber numberWithDouble:length];
    NSLog(@"%f \n %f", length, self.currentLength.floatValue);
    return length;
}

@end
