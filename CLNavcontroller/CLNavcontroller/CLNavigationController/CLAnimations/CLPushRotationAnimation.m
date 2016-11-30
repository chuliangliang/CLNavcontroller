//
//  CLPushRotationAnimation.m
//  CLNavcontroller
//
//  Created by chuliangliang on 2016/11/30.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import "CLPushRotationAnimation.h"

@implementation CLPushRotationAnimation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rotationOrientation = RotationOrientationRight;
    }
    return self;
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
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
    
    UIView *rotationView = nil;
    CGFloat rotationInit = 0;
    CGFloat rotationFinish = 0;
    
    if (self.type == AnimationTypePush) {
        rotationView = toViewController.view;
        
        //push 动作
        if (self.rotationOrientation == RotationOrientationLeft) {
            //push 方向 为从左侧进入
            fromInitX = 0;
            toInitX = 0;
            rotationInit = -(M_PI / 4 * 3);
            rotationFinish = 0;
    
        }else if (self.rotationOrientation == RotationOrientationRight) {
            //push 方向 为右侧进入
            fromInitX = 0;
            toInitX = 0;
            rotationInit = M_PI / 4 * 3;
            rotationFinish = 0;
        }
        /**
         * 将两个ViewController 跟视图添加在容器中
         * 将要退出屏幕的ViewController 先添加显示在最底层 将要进入的ViewController 后添加显示在最上层
         **/
        [containerView addSubview:fromViewController.view];
        [containerView addSubview:toViewController.view];
        

        
    }else if (self.type == AnimationTypePop) {
        rotationView = fromViewController.view;
        //pop 动作
        if (self.rotationOrientation == RotationOrientationLeft) {
            //push 方向 为从左侧进入
            fromInitX = 0;
            toInitX = 0;
            rotationInit = 0;
            rotationFinish = -(M_PI / 4 * 3);
        }else if (self.rotationOrientation == RotationOrientationRight) {
            //push 方向 为右侧进入
            fromInitX = 0;
            toInitX = 0;
            rotationInit = 0;
            rotationFinish = M_PI / 4 * 3;

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
    
    //设置选中View 锚点
    [self setAnchorPoint:CGPointMake(0.5, 1.2) forView:rotationView];
    rotationView.transform = CGAffineTransformMakeRotation(rotationInit);
    

    /**
     * 创建动画并将两个ViewController 移动到最终位置
     */
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        rotationView.transform = CGAffineTransformMakeRotation(rotationFinish);
//        rotationView.transform = CGAffineTransformIdentity;
        
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:rotationView];
        if (alphaLayer) {
            [alphaLayer removeFromSuperlayer];
        }
    }];
    
    
    if (alphaLayer) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode = kCAFillModeForwards;
        opacityAnimation.duration = duration * 0.5;
        [alphaLayer addAnimation:opacityAnimation forKey:@"aplhaLayer-opacity"];
        
    }
    
    
}
- (void)setFrameOriginX:(CGFloat)x forView:(UIView *)view withFrame:(CGRect)frame
{
    frame.origin.x = x;
    view.frame = frame;
}

//设置防止view刚开始旋转时发生跳屏
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

@end
