//
//  TYTitleViewController.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYTitleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TYHelpViewController.h"

@implementation TYTitleViewController {
  ADBannerView *_adbanner;
  BOOL _bannerIsVisble;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    //iAd
    _adbanner = [TYAdManager sharedAdBannerView];
    _adbanner.frame = CGRectMake(0, self.view.bounds.size.height, _adbanner.frame.size.width, _adbanner.frame.size.height);
    _adbanner.delegate = self;
    _adbanner.autoresizesSubviews = YES;
    _adbanner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _adbanner.alpha = 0.0;
    [self.view addSubview:_adbanner];
  }
  return self;
}

/*GameCenterにログインしているか確認処理*/
- (void)authenticateLocalPlayer
{
  GKLocalPlayer *player = [GKLocalPlayer localPlayer];
  player.authenticateHandler = ^(UIViewController *ui, NSError *error)
  {
    if (error) {
      LOG(@"error:%@",error)
    }
    LOG()
    if (nil != ui) {
    LOG()
      [self presentViewController:ui animated:YES completion:nil];
    }
  };
}
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
  LOG()
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //背景
  UIImage *background = [UIImage imageNamed:@"Top"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:background];
  //タイトル
  UIImage *ttlImg = [UIImage imageNamed:@"Logo"];
  UIImageView *title = [[UIImageView alloc] initWithImage:ttlImg];
  title.contentMode = UIViewContentModeCenter;
  
  title.frame = CGRectMake(self.view.bounds.size.width/2-ttlImg.size.width/2, 150, ttlImg.size.width, ttlImg.size.height);
  [self.view addSubview:title];
  
  //スタートボタン
  CGRect startFrame = CGRectMake(self.view.frame.size.width/2-70, self.view.frame.size.height/2-10, 140, 50);
  NSString *start = @"START";
  UIButton *startBtn = [self makeButton:startFrame text:start];
  [startBtn addTarget:self action:@selector(gameStart) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:startBtn];
  //ランキング
  CGRect rankingFrame = CGRectMake(self.view.frame.size.width/2-70, self.view.frame.size.height/2+60, 140, 50);
  NSString *ranking = @"RANKING";
  UIButton *rankingBtn = [self makeButton:rankingFrame text:ranking];
  [rankingBtn addTarget:self action:@selector(ranking) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:rankingBtn];
  //遊び方
  CGRect helpFrame = CGRectMake(self.view.frame.size.width/2-70, self.view.frame.size.height/2+130, 140, 50);
  NSString *help = @"HELP";
  UIButton *helpBtn = [self makeButton:helpFrame text:help];
  [helpBtn addTarget:self action:@selector(showHelp) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:helpBtn];
  
  [self authenticateLocalPlayer];
  
}

- (UIButton *)makeButton:(CGRect)rect text:(NSString *)text
{
  UIButton *Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  Btn.titleLabel.font = [UIFont fontWithName:@"HirakakuProN-W6" size:18];
  Btn.layer.borderColor = [[UIColor whiteColor] CGColor];
  Btn.layer.borderWidth = 1.0;
  Btn.layer.cornerRadius = 10;
  [Btn setFrame:rect];
  [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [Btn setTitle:text forState:UIControlStateNormal];
 
  return Btn;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//  [self gameStart];
}

- (void)blinkText:(UILabel *)target
{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  animation.duration = 0.8f;
  animation.autoreverses = YES;
  animation.repeatCount = HUGE_VAL;
  animation.fromValue = [NSNumber numberWithFloat:1.0f];
  animation.toValue = [NSNumber numberWithFloat:0.0f];
  [target.layer addAnimation:animation forKey:@"blink"];
}

- (void)gameStart
{
  if ([_delegate respondsToSelector:@selector(titleViewControllerGameStart:)]) {
    [_delegate titleViewControllerGameStart:self];
  }
}

//GameCenterランキング
- (void)ranking
{
  LOG()
  GKGameCenterViewController *gcView = [GKGameCenterViewController new];
  if (gcView != nil) {
    gcView.gameCenterDelegate = self;
    gcView.viewState = GKGameCenterViewControllerStateLeaderboards;
    [self presentViewController:gcView animated:YES completion:nil];
  }
}

//ヘルプ
- (void)showHelp
{
  TYHelpViewController *helpView = [[TYHelpViewController alloc] initWithNibName:nil bundle:nil];
  [self presentViewController:helpView animated:YES completion:nil];
  
}

//iAd
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  if (!_bannerIsVisble) {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       CGRect frame = _adbanner.frame;
                       frame.origin.y -= _adbanner.frame.size.height;
                       _adbanner.frame = frame;
                       _adbanner.alpha = 1.0;
                     }completion:^(BOOL finished){
                       _bannerIsVisble = YES;
                     }];
  }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
  if (_bannerIsVisble) {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       CGRect frame = _adbanner.frame;
                       frame.origin.y += _adbanner.frame.size.height;
                       _adbanner.frame = frame;
                       _adbanner.alpha = 0.0;
                     }completion:^(BOOL finished){
                       _bannerIsVisble = NO;
                     }];
  }
}

@end
