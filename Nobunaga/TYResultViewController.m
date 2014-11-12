//
//  TYResultViewController.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYResultViewController.h"
#import "TYGamePlayTimeManager.h"
#import <GameKit/GameKit.h>

@interface TYResultViewController () {
  TYGamePlayTimeManager *_sharedManager;
  float _timerCount;
  ADBannerView *_adbanner;
  BOOL _bannerIsVisble;
}

@end

@implementation TYResultViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //iAd
  _adbanner = [TYAdManager sharedAdBannerView];
  _adbanner.frame = CGRectMake(0, self.view.bounds.size.height, _adbanner.frame.size.width, _adbanner.frame.size.height);
  _adbanner.delegate = self;
  _adbanner.autoresizesSubviews = YES;
  _adbanner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
  _adbanner.alpha = 0.0;
  [self.view addSubview:_adbanner];
  
//  self.view.backgroundColor = [UIColor whiteColor];
  
  //モデルマネージャー
  _sharedManager = [TYGamePlayTimeManager sharedmanager];
  _timerCount = [_sharedManager fetchTime];
  float second = fmodf(_timerCount, 60);
  int minute = _timerCount / 60;
  NSString *timeTxt = [NSString stringWithFormat:@"%02d:%02.0f", minute, second];
  
  //背景
  UIImage *background = [UIImage imageNamed:@"Scenario"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:background];
  //炎点滅
//  UIImage *fire = [UIImage imageNamed:@"Fire"];
//  UIImageView *fireEffect = [[UIImageView alloc] initWithImage:fire];
//  [self.view addSubview:fireEffect];
//  [self blinkImage:fireEffect];
  
  //スコアラベル
  UILabel *ttl = [[UILabel alloc] init];
  ttl.frame = CGRectMake(self.view.frame.size.width/2-90, 100 , 200, 50);
  ttl.text = @"今回のスコア";
  ttl.font = [UIFont fontWithName:@"HirakakuProN-W6" size:30];
  ttl.backgroundColor = [UIColor blackColor];
  ttl.textColor = [UIColor whiteColor];
  ttl.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:ttl];
  
  UILabel *score = [[UILabel alloc] init];
  score.frame = CGRectMake(self.view.frame.size.width/2-100, 180, 200, 50);
  score.font = [UIFont fontWithName:@"HirakakuProN-W6" size:36];
  score.textColor = [UIColor whiteColor];
  score.textAlignment = NSTextAlignmentCenter;
  score.text = timeTxt;
  [self.view addSubview:score];
  
  //トップ画面リンクボタン
  CGRect topFrame = CGRectMake(self.view.frame.size.width/2-70, self.view.frame.size.height/2+20, 140, 50);
  NSString *top = @"TOP";
  UIButton *topBtn = [self makeButton:topFrame text:top];
  [topBtn addTarget:self action:@selector(backToTitle) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:topBtn];
  //リプレイ
  CGRect replayFrame = CGRectMake(self.view.frame.size.width/2-70, self.view.frame.size.height/2+100, 140, 50);
  NSString *replay = @"REPLAY";
  UIButton *replayBtn = [self makeButton:replayFrame text:replay];
  [replayBtn addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:replayBtn];
  
//  [self scoreSend];
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

- (void)scoreSend
{
  LOG()
  if ([GKLocalPlayer localPlayer].isAuthenticated) {
  LOG()
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:LEADERBOARD_ID];
    score.value = _timerCount;
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
      if (error) {
        LOG(@"error: %@", error)
      }
    }];
  }
}

- (void)blinkImage:(UIImageView *)target
{
  LOG()
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  animation.duration = 0.9f;
  animation.autoreverses = YES;
  animation.repeatCount = HUGE_VAL;
  animation.fromValue = [NSNumber numberWithFloat:1.0f];
  animation.toValue = [NSNumber numberWithFloat:0.2f];
  [target.layer addAnimation:animation forKey:@"blink"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)retry
{
  LOG()
  //デリゲート通知
  if ([_delegate respondsToSelector:@selector(resultViewControllerRetry:)]) {
    [_delegate resultViewControllerRetry:self];
  }
}

- (void)backToTitle
{
  LOG()
  //デリゲート通知
  if ([_delegate respondsToSelector:@selector(resultviewcontrollerBackTitle:)]) {
    [_delegate resultviewcontrollerBackTitle:self];
  }
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
