//
//  SGMNavigationController.m
//  SGMNavigationProj
//
//  Created by guimingsu on 15/6/5.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "SGMNavigationController.h"

@interface SGMNavigationController ()

@property (strong,nonatomic) SGMPushAnimator * pushAnimator; //push 动画
@property (strong,nonatomic) SGMPopAnimator * popAnimator;   //pop 动画
@property (strong,nonatomic) UIPercentDrivenInteractiveTransition * interactionController; //动画百分比

@end

@implementation SGMNavigationController

@synthesize isSupportPenGesture;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //禁用ios7自带的手势返回
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    //代理设置为该类
    self.delegate= self;
    
    //添加拖动手势
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
    //默认开启
    isSupportPenGesture = YES;
    
    self.pushAnimator = [[SGMPushAnimator alloc]init];
    self.popAnimator  = [[SGMPopAnimator alloc]init];
    
}

//手势处理
-(void)handlePanGesture:(UIPanGestureRecognizer*)recognizer{

    //活动动画关闭
    if (!isSupportPenGesture){
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        //动画百分比(必须写这里 然后用完后设为 nil 这是关键 否则 点击back 会有问题)
        self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
         CGPoint translation = [recognizer translationInView:self.view];
         CGFloat percent = translation.x / CGRectGetWidth(self.view.bounds);
         percent = percent<0?0:percent;

        [self.interactionController updateInteractiveTransition:percent];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if ([recognizer velocityInView:self.view].x > 0)
        {
            [self.interactionController finishInteractiveTransition];
        }
        else
        {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController= nil; //必须
    }else{
        self.interactionController = nil;//必须
     }
    
}
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        return nil;
        //return  self.pushAnimator; //或者自定义push 动画
    }
    if (operation == UINavigationControllerOperationPop){
        
        return  self.popAnimator;
    }
    return nil;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.interactionController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end

#pragma mark --- push Animator
@implementation SGMPushAnimator
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    //或者自定义push 动画

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{

    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];//必须
    }];
}
@end

#pragma mark --- pop Animator
@implementation SGMPopAnimator
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    fromViewController.view.transform = CGAffineTransformMakeScale(1, 1);
    toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
    
    //预设在左边一点
    CGRect toViewFrame  = toViewController.view.frame;
    toViewFrame.origin.x = -toViewFrame.size.width*0.3;
    toViewController.view.frame = toViewFrame;
    
    //这个必须这样
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    toViewController.view.alpha = 0.5;

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{

        CGRect fromViewFrame  = fromViewController.view.frame;
        fromViewFrame.origin.x = fromViewFrame.size.width;
        fromViewController.view.frame = fromViewFrame;

        CGRect toViewFrame  = toViewController.view.frame;
        toViewFrame.origin.x = 0;
        toViewController.view.frame = toViewFrame;
        toViewController.view.alpha = 1;
 
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        toViewController.view.transform = CGAffineTransformIdentity;
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end


