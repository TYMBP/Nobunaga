//
//  TYAdManager.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/09/28.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYAdManager.h"

static TYAdManager *_adManager;
static ADBannerView *_adBannerView;

@implementation TYAdManager {
  BOOL _bannerIsVisble;
}

+ (ADBannerView *)sharedAdBannerView
{
  if (_adBannerView == nil) {
    _adManager = [[TYAdManager alloc] init];
    _adBannerView = [[ADBannerView alloc] init];
    _adBannerView.delegate = _adManager;
    _adBannerView.autoresizesSubviews = YES;
    _adBannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _adBannerView.alpha = 0.0;
  }
  return _adBannerView;
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  if (!_bannerIsVisble) {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       CGRect frame = _adBannerView.frame;
                       frame.origin.y -= _adBannerView.frame.size.height;
                       _adBannerView.frame = frame;
                       _adBannerView.alpha = 1.0;
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
                       CGRect frame = _adBannerView.frame;
                       frame.origin.y += _adBannerView.frame.size.height;
                       _adBannerView.frame = frame;
                       _adBannerView.alpha = 0.0;
                     }completion:^(BOOL finished){
                       _bannerIsVisble = NO;
                     }];
  }
}

@end
