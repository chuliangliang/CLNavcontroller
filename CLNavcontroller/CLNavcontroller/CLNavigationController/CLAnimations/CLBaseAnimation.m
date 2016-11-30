//
//  BaseAnimation.m
//  CLNews
//
//  Created by chuliangliang on 16/10/12.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import "CLBaseAnimation.h"

@implementation CLBaseAnimation


#pragma mark - UIViewControllerAnimatedTransitioning

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSAssert(NO, @"animateTransition: should be handled by subclass of BaseAnimation");
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

-(void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    NSAssert(NO, @"handlePinch: should be handled by a subclass of BaseAnimation");
}

@end
