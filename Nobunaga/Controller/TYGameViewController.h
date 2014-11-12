//
//  TYGameViewController.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYGameView.h"
#import "TYAdManager.h"

@interface TYGameViewController : UIViewController <ADBannerViewDelegate>
@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) TYGameView *gameView;
@end

//デリゲート
@protocol TYGameViewControllerDelegate <NSObject>
- (void)gameViewControllerGameOver:(TYGameViewController *)title;
- (void)gameViewControllerRetire:(TYGameViewController *)title;
@end
