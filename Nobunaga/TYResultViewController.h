//
//  TYResultViewController.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TYAdManager.h"

@interface TYResultViewController : UIViewController <ADBannerViewDelegate>
@property (weak, nonatomic) id delegate;
- (void)retry;
- (void)backToTitle;
@end

//デリゲート
@protocol TYResultViewControllerDelegate <NSObject>
- (void)resultViewControllerRetry:(TYResultViewController *)result;
- (void)resultviewcontrollerBackTitle:(TYResultViewController *)result;
@end