//
//  TYViewControllerManager.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYViewControllerManager.h"

@interface TYViewControllerManager()
+ (TYTitleViewController *)titleViewController;
+ (TYGameViewController *)gameViewController;
+ (TYResultViewController *)resultViewController;
- (void)viewChange:(UIViewController *)childViewController;
@end

@implementation TYViewControllerManager

+ (UIViewController *)titleViewController;
{
  TYTitleViewController *viewcnt = [[TYTitleViewController alloc] init];
  return viewcnt;
}

+ (UIViewController *)gameViewController
{
  TYGameViewController *viewcnt = [[TYGameViewController alloc] init];
  return viewcnt;
}

+ (UIViewController *)resultViewController
{
  TYResultViewController *viewcnt = [[TYResultViewController alloc] init];
  return viewcnt;
}

//ビューコントローラーの切替
- (void)switchingTitleViewController:(UIViewController *)parentViewController
{
  self.parentViewController = parentViewController;
  [self viewChange:[TYViewControllerManager titleViewController]];
}

- (void)switchingGameViewController:(UIViewController *)parentViewController
{
  self.parentViewController = parentViewController;
  [self viewChange:[TYViewControllerManager gameViewController]];
}

- (void)switchingResultViewController:(UIViewController *)parentViewController
{
  self.parentViewController = parentViewController;
  [self viewChange:[TYViewControllerManager resultViewController]];
}

- (void)viewChange:(UIViewController *)childViewController
{
  for (UIViewController *vc in [self.parentViewController childViewControllers]) {
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
  }
  self.childViewController = childViewController;
  [self.parentViewController addChildViewController:self.childViewController];
  [self.parentViewController.view addSubview:self.childViewController.view];
  
  //アニメーション
  self.childViewController.view.alpha = 0.0;
  [UIView animateWithDuration:0.5
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     self.childViewController.view.alpha = 1.0;
                   }
                   completion:^(BOOL finished){
                     
                   }];
  if ([self.childViewController class] == [TYTitleViewController class]) {
    TYTitleViewController *vc = (TYTitleViewController *)self.childViewController;
    vc.delegate = self;
  } else if ([self.childViewController class] == [TYGameViewController class]) {
    TYGameViewController *vc = (TYGameViewController *)self.childViewController;
    vc.delegate = self;
  } else if ([self.childViewController class] == [TYResultViewController class]) {
    TYResultViewController *vc = (TYResultViewController *)self.childViewController;
    vc.delegate = self;
  }
}

- (void)titleViewControllerGameStart:(TYTitleViewController *)title
{
  LOG()
  [self viewChange:[TYViewControllerManager gameViewController]];
}

- (void)gameViewControllerGameOver:(TYGameViewController *)title
{
  LOG()
  [self viewChange:[TYViewControllerManager resultViewController]];
}

- (void)gameViewControllerRetire:(TYGameViewController *)title
{
  LOG()
  [self viewChange:[TYViewControllerManager titleViewController]];
}

- (void)resultViewControllerRetry:(TYResultViewController *)result
{
  LOG()
  [self viewChange:[TYViewControllerManager gameViewController]];
}
- (void)resultviewcontrollerBackTitle:(TYResultViewController *)result
{
  LOG()
  [self viewChange:[TYViewControllerManager titleViewController]];
}

@end
