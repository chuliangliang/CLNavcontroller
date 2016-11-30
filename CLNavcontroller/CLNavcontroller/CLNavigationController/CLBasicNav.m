//
//  CLBasicNav.m
//  CLVideoLive
//
//  Created by chuliangliang on 16/8/4.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import "CLBasicNav.h"
#import "CLPushAnimation.h"
#import "CLPushRotationAnimation.h"

@interface CLBasicNav ()<UINavigationControllerDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *mInteractivePopTransition;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenEdgeGesture;

@end

@implementation CLBasicNav

-(void)dealloc
{
    self.mInteractivePopTransition = nil;
    
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)doInit {
    self.mOrientation = CLAnimateOrientation_right;
    
    self.screenEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanAction:)];
    self.screenEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:self.screenEdgeGesture];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

#pragma mark -
#pragma mark - setter
- (void)setMOrientation:(CLAnimateOrientation)mOrientation
{
    _mOrientation = mOrientation;
    
    switch (_mOrientation) {
        case CLAnimateOrientation_left:
        case CLAnimateRotation_clockwise:
        {
            self.screenEdgeGesture.edges = UIRectEdgeRight;
        }
            break;
        case CLAnimateOrientation_right:
        case CLAnimateRotation_antiClockwise:
        {
            self.screenEdgeGesture.edges = UIRectEdgeLeft;
        }
            break;
        default:
            break;
    }
    
}


#pragma mark -
#pragma mark - Navigation Controller Delegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    


    switch (operation) {
        case UINavigationControllerOperationPush:
        {
            switch (self.mOrientation) {
                case CLAnimateOrientation_left:
                case CLAnimateOrientation_right:
                {
                    CLPushAnimation *pushAnimate = [CLPushAnimation new];
                    pushAnimate.type = AnimationTypePush;
                    pushAnimate.pushOrientation = self.mOrientation == CLAnimateOrientation_left?PushOrientationLeft:PushOrientationRight;
                    return  pushAnimate;

                }
                    break;
                case CLAnimateRotation_clockwise:
                case CLAnimateRotation_antiClockwise:
                {
                    CLPushRotationAnimation *popAnimate = [CLPushRotationAnimation new];
                    popAnimate.type = AnimationTypePush;
                    popAnimate.rotationOrientation = self.mOrientation == CLAnimateRotation_clockwise?RotationOrientationLeft:RotationOrientationRight;
                    return  popAnimate;

                }
                    break;
                    
                default:
                    break;
            }
        }
        case UINavigationControllerOperationPop:
        {
            
            switch (self.mOrientation) {
                case CLAnimateOrientation_left:
                case CLAnimateOrientation_right:
                {
                    CLPushAnimation *popAnimate = [CLPushAnimation new];
                    popAnimate.type = AnimationTypePop;
                    popAnimate.pushOrientation = self.mOrientation == CLAnimateOrientation_left?PushOrientationLeft:PushOrientationRight;
                    return  popAnimate;
                    
                }
                    break;
                case CLAnimateRotation_clockwise:
                case CLAnimateRotation_antiClockwise:
                {
                    CLPushRotationAnimation *popAnimate = [CLPushRotationAnimation new];
                    popAnimate.type = AnimationTypePop;
                    popAnimate.rotationOrientation = self.mOrientation == CLAnimateRotation_clockwise?RotationOrientationLeft:RotationOrientationRight;
                    return  popAnimate;

                }
                    break;

                default:
                    break;
            }

        }
        default: return nil;
    }
    
}


- (void)screenEdgePanAction:(UIScreenEdgePanGestureRecognizer *)gesture {
    
    CGFloat W = CGRectGetWidth(self.view.bounds);
    CGFloat x = [gesture translationInView:self.view].x;
    
    CGPoint speedPoint = [gesture velocityInView:self.view];
    CGFloat speedX = 0;

    switch (self.mOrientation) {
        case CLAnimateOrientation_left:
        {
            x = MIN(x, 0);
            speedX = MAX(0, speedPoint.x*-1);

        }
            break;
        case CLAnimateOrientation_right:
        {
            x = MAX(0, x);
            speedX = MAX(0, speedPoint.x);
        }
            break;
        case CLAnimateRotation_clockwise:
        {
            x = MIN(0, x);
            x *= 0.5;
            speedX = MAX(0, speedPoint.x*-1);

            
        }
            break;
        case CLAnimateRotation_antiClockwise:
        {
            x = MAX(x, 0);
            x *= 0.5;
            speedX = MAX(0, speedPoint.x);

        }
            break;
        default:
            break;
    }
    
    CGFloat offsetX = fabs(x);
    
    
    CGFloat progress =  offsetX / W;
    progress = MIN(1.0, MAX(0.0, progress));
    
    
    NSLog(@"手指拖动的速度: %@ x: %f",NSStringFromCGPoint(speedPoint),x);
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 创建过渡对象，弹出viewController
        self.mInteractivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self popViewControllerAnimated:YES];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        // 更新 interactive transition 的进度
        [self.mInteractivePopTransition updateInteractiveTransition:progress];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        
        /**
         * 完成或者取消过渡
         * 拖动速度 超过200/秒 或者 已经拖动距离超过一半 则判断为完成 否则判为取消
         **/
        if (progress > 0.5 || speedX > 200) {
            [self.mInteractivePopTransition finishInteractiveTransition];
        }
        else {
            [self.mInteractivePopTransition cancelInteractiveTransition];
        }
        
        self.mInteractivePopTransition = nil;
    }
    
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    return self.mInteractivePopTransition;

}
@end
