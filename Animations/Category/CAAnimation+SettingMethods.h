//
//  CAAnimation+SettingMethods.h
//  Animations
//
//  Created by Non on 16/7/30.
//  Copyright © 2016年 NonMac. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (SettingMethods)

/**
 *  @author NonMac, 16-07-30 09:07:18
 *
 *  get a CABasicAnimation method with settings(获取自定义CABasicAnimation)
 *  @param keypath      <#keypath description#>
 *  @param fromValue    <#fromValue description#>
 *  @param toValue      <#toValue description#>
 *  @param duration     <#duration description#>
 *  @param isRepeat     <#isRepeat description#>
 *  @param timeFunction <#timeFunction description#>
 *  @return <#return value description#>
 */
+ (CABasicAnimation *)getBasicAniForKeypath:(NSString *)keypath
                                       from:(id)fromValue
                                         to:(id)toValue
                                   duration:(NSTimeInterval)duration
                                    reapeat:(BOOL)isRepeat
                               timeFunction:(NSString *)timeFunction;

@end
