//
//  CLBasicNav.h
//  CLVideoLive
//
//  Created by chuliangliang on 16/8/4.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, CLAnimateOrientation) {
    CLAnimateOrientation_left,
    CLAnimateOrientation_right,
    
    CLAnimateRotation_clockwise,
    CLAnimateRotation_antiClockwise,
};
@interface CLBasicNav : UINavigationController

/**
 * Push 动画方向|类型 默认 CLAnimateOrientation_right
 */
@property (nonatomic,assign) CLAnimateOrientation mOrientation;
@end
