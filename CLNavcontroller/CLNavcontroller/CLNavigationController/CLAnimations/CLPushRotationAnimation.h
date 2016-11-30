//
//  CLPushRotationAnimation.h
//  CLNavcontroller
//
//  Created by chuliangliang on 2016/11/30.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import "CLBaseAnimation.h"


typedef NS_ENUM(NSInteger, RotationOrientation) {
    RotationOrientationLeft,
    RotationOrientationRight,
};
@interface CLPushRotationAnimation : CLBaseAnimation
@property (assign,nonatomic) RotationOrientation rotationOrientation;
@end
