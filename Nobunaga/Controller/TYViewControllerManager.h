//
//  TYViewControllerManager.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTitleViewController.h"
#import "TYGameViewController.h"
#import "TYResultViewController.h"

@interface TYViewControllerManager : NSObject
@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) UIViewController *childViewController;

//ビューコントローラ-切替
- (void)switchingTitleViewController:(UIViewController *)parentViewController;
- (void)switchingGameViewController:(UIViewController *)parentViewController;
- (void)switchingResultViewController:(UIViewController *)parentViewController;
@end
