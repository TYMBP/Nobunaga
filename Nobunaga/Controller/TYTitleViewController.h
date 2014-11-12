//
//  TYTitleViewController.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <GameKit/GameKit.h>
#import "TYAdManager.h"

@interface TYTitleViewController : UIViewController <GKGameCenterControllerDelegate, ADBannerViewDelegate>
@property (weak, nonatomic) id delegate;
- (void)gameStart;
@end
//デリゲートメソッド
@protocol TYTitleViewControllerDelegate <NSObject>
- (void)titleViewControllerGameStart:(TYTitleViewController *)title;
@end
