//
//  PushAnimation.h
//  CLNews
//
//  Created by chuliangliang on 16/10/12.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import "CLBaseAnimation.h"

typedef NS_ENUM(NSInteger, PushOrientation) {
    PushOrientationLeft,
    PushOrientationRight,
};
@interface CLPushAnimation : CLBaseAnimation
@property (assign,nonatomic)PushOrientation pushOrientation;
@end
