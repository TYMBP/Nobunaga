//
//  TYGameViewController.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYGameViewController.h"
#import "TYGamePlayTimeManager.h"

@interface TYGameViewController () {
  TYGamePlayTimeManager *_sharedManager;
  ADBannerView *_adbanner;
  BOOL _bannerIsVisble;
}

@end

@implementation TYGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _sharedManager = [TYGamePlayTimeManager sharedmanager];
    
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

- (void)viewDidLoad
{
  [super viewDidLoad];
    // Do any additional setup after loading the view.
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(retire) name:@"retire" object:nil];
//  [nc addObserver:self selector:@selector(gameOver) name:@"gameOver" object:nil];
  
  self.gameView = [[TYGameView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:self.gameView];
  
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  //ゲームオーバーチェック
  BOOL gameOverFlg = [_sharedManager fetchFlag];
  if (gameOverFlg) {
    [_sharedManager updateFlag];
    [self gameOver];
  }
  
}

- (void)gameOver
{
  //デリゲート通知
  LOG()
  if ([_delegate respondsToSelector:@selector(gameViewControllerGameOver:)]) {
    [_delegate gameViewControllerGameOver:self];
  }
}

- (void)retire
{
  LOG()
  //デリゲート通知
  if ([_delegate respondsToSelector:@selector(gameViewControllerRetire:)]) {
    [_delegate gameViewControllerRetire:self];
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
