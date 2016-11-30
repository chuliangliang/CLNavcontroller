//
//  PushAnimation.m
//  CLNews
//
//  Created by chuliangliang on 16/10/12.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import "CLPushAnimation.h"

@implementation CLPushAnimation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pushOrientation = PushOrientationRight;
    }
    return self;
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return .3;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CALayer *alphaLayer = [CALayer layer];
    alphaLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    
    /**
     *  fromViewController: 即将退出屏幕的ViewController
     *  toViewController: 即将要进入屏幕的ViewController
     *  containerView: 两个ViewController 临时过渡的容器View
     */
    
    CGRect fromeRect = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toRect = [transitionContext finalFrameForViewController:toViewController];
    CGFloat fromInitX = 0;
    CGFloat toInitX = 0;
    CGFloat fromFinishX = 0;
    CGFloat toFinishX = 0;
    
    if (self.type == AnimationTypePush) {
        //push 动作
        if (self.pushOrientation == PushOrientationLeft) {
            //push 方向 为从左侧进入
            fromInitX = 0;
            fromFinishX = CGRectGetWidth(fromeRect)*0.5;
            
            toInitX = -CGRectGetWidth(toRect);
            toFinishX = 0;
        }else if (self.pushOrientation == PushOrientationRight) {
            //push 方向 为右侧进入
            fromInitX = 0;
            fromFinishX = -CGRectGetWidth(fromeRect)*0.5;
            
            toInitX = CGRectGetWidth(toRect);
            toFinishX = 0;
            
        }
        /**
         * 将两个ViewController 跟视图添加在容器中
         * 将要退出屏幕的ViewController 先添加显示在最底层 将要进入的ViewController 后添加显示在最上层
         **/
        [containerView addSubview:fromViewController.view];
        [containerView addSubview:toViewController.view];

    }else if (self.type == AnimationTypePop) {
        //pop 动作
        if (self.pushOrientation == PushOrientationLeft) {
            //push 方向 为从左侧进入
            fromInitX = 0;
            fromFinishX = -CGRectGetWidth(fromeRect);
            
            toInitX = CGRectGetWidth(toRect)*0.5;
            toFinishX = 0;
        }else if (self.pushOrientation == PushOrientationRight) {
            //push 方向 为右侧进入
            fromInitX = 0;
            fromFinishX = CGRectGetWidth(fromeRect);
            
            toInitX = -CGRectGetWidth(toRect)*0.5;
            toFinishX = 0;
            
        }
        /**
         * 将两个ViewController 跟视图添加在容器中
         * 将要进入的ViewController 先添加显示在最底层 将要退出屏幕的ViewController 后添加显示在最顶层
         **/
        [containerView addSubview:toViewController.view];
        [containerView addSubview:fromViewController.view];

        /**
         * 添加半透明layer
         */
        alphaLayer.frame = toViewController.view.bounds;
        [toViewController.view.layer addSublayer:alphaLayer];

    }

    
    /**
     * 设置两个ViewController 的初始位置
     */
    [self setFrameOriginX:fromInitX forView:fromViewController.view withFrame:fromeRect];
    [self setFrameOriginX:toInitX forView:toViewController.view withFrame:toRect];

    

    /**
     * 创建动画并将两个ViewController 移动到最终位置
     */
    fromeRect.origin.x = fromFinishX;
    toRect.origin.x = toFinishX;
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromViewController.view.frame = fromeRect;
        toViewController.view.frame = toRect;
        

    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
        if (alphaLayer) {
            [alphaLayer removeFromSuperlayer];
        }
    }];
    
    
    if (alphaLayer) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        opacityAnimation.duration = duration * 0.9;
        [alphaLayer addAnimation:opacityAnimation forKey:@"aplhaLayer-opacity"];
        
    }
    
    
    /*
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    CGRect toVCNewRect = [transitionContext finalFrameForViewController:toViewController];
    CGRect fromVCNewRect = [transitionContext initialFrameForViewController:fromViewController];
    
    UIViewController *maskViewController = nil;
    
    CGFloat maskLayerX = 0;
    CGFloat maskLayerHeight = 0;
    if (self.type == AnimationTypePush) {
        //设置动画开始之前的起始frame
        CGFloat fVCWidth = CGRectGetWidth(fromVCNewRect);
        CGFloat tVCInitX = 0;
        CGFloat fVCInitX = 0;
        
        CGFloat fVCFinalX = 0;
        CGFloat tVCFinalX = 0;
        if (PushOrientationLeft == self.pushOrientation) {
            maskLayerHeight = CGRectGetHeight(toViewController.view.frame);
            [containerView addSubview:toViewController.view];

            //起点坐标
            tVCInitX = fVCWidth;
            fVCInitX = 0;
            
            //终点坐标
            tVCFinalX= 0;
            fVCFinalX = -fVCWidth;
        }else if (PushOrientationRight == self.pushOrientation){
            maskLayerHeight = CGRectGetHeight(fromViewController.view.frame);
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
            
            //起点坐标
            tVCInitX = -fVCWidth;
            fVCInitX = 0;
            
            //终点坐标
            fVCFinalX = fVCWidth;
            tVCFinalX = 0;
        }
        
        [self setFrameOriginX:fVCInitX forView:fromViewController.view withFrame:fromVCNewRect];
        [self setFrameOriginX:tVCInitX forView:toViewController.view withFrame:toVCNewRect];
        
        //计算动画结束的终点frame
        toVCNewRect.origin.x = tVCFinalX;
        fromVCNewRect.origin.x = fVCFinalX;
        maskLayerX = -fVCWidth;
        
    } else if (self.type == AnimationTypePop) {
        
        
        //设置动画开始之前的起始frame
        CGFloat tVCWidth = CGRectGetWidth(toVCNewRect);
        CGFloat tVCInitX = 0;
        CGFloat fVCInitX = 0;
        
        CGFloat fVCFinalX = 0;
        CGFloat tVCFinalX = 0;
        
        if (PushOrientationLeft == self.pushOrientation) {
            maskViewController = fromViewController;

            [containerView addSubview:toViewController.view];
            
            //起点坐标
            tVCInitX = -tVCWidth;
            fVCInitX = 0;
            
            //终点坐标
            tVCFinalX= 0;
            fVCFinalX = tVCWidth;

        }else if (PushOrientationRight == self.pushOrientation){
            maskViewController = toViewController;
            [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];

            //起点坐标
            tVCInitX = tVCWidth/2.0;
            fVCInitX = 0;
            
            //终点坐标
            fVCFinalX = -tVCWidth;
            tVCFinalX = 0;

        }

        [self setFrameOriginX:fVCInitX forView:fromViewController.view withFrame:fromVCNewRect];
        [self setFrameOriginX:tVCInitX forView:toViewController.view withFrame:toVCNewRect];
        
        //计算动画结束的终点frame
        toVCNewRect.origin.x = tVCFinalX;
        fromVCNewRect.origin.x = fVCFinalX;
        
        maskLayerX = tVCWidth;
        
        

    }
    

    //添加阴影
    CAGradientLayer *fromeVCGradientLayer = [CAGradientLayer layer];
    fromeVCGradientLayer.frame = CGRectMake(maskLayerX, 0, 10, CGRectGetHeight(maskViewController.view.frame));
    fromeVCGradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:100/255.0 alpha:0.2].CGColor,(id)[UIColor clearColor].CGColor,nil];
    fromeVCGradientLayer.locations = @[[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.8]];
    fromeVCGradientLayer.startPoint = CGPointMake(0, 0);
    fromeVCGradientLayer.endPoint = CGPointMake(1, 0);
    [fromViewController.view.layer addSublayer:fromeVCGradientLayer];

    
    CGFloat duration = [self transitionDuration:transitionContext];
    NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
    fromeVCGradientLayer.actions = newActions;
    CGRect gradientlayerFrame = fromeVCGradientLayer.frame;
    gradientlayerFrame.origin.x = CGRectGetMaxX(fromViewController.view.frame);
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromViewController.view.frame = fromVCNewRect;
        toViewController.view.frame = toVCNewRect;
        fromeVCGradientLayer.frame = gradientlayerFrame;
        
    } completion:^(BOOL finished) {
        [fromeVCGradientLayer removeFromSuperlayer];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
*/
}
- (void)setFrameOriginX:(CGFloat)x forView:(UIView *)view withFrame:(CGRect)frame
{
    frame.origin.x = x;
    view.frame = frame;
}

@end
