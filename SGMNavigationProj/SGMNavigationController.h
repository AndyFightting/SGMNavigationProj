//
//  SGMNavigationController.h
//  SGMNavigationProj
//
//  Created by guimingsu on 15/6/5.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGMNavigationController : UINavigationController<UINavigationControllerDelegate>
@property(nonatomic) BOOL isSupportPenGesture; //是否开启手势返回  默认开启
@end
//push 动画
@interface SGMPushAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@end
//pop 动画
@interface SGMPopAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@end