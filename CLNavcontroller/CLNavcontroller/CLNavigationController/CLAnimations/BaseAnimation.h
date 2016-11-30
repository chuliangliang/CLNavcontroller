//
//  BaseAnimation.h
//  CLNews
//
//  Created by chuliangliang on 16/10/12.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
    AnimationTypePush,
    AnimationTypePop,
} AnimationType;


@interface BaseAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) AnimationType type;
@end
