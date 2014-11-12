//
//  TYAdManager.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/09/28.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface TYAdManager : NSObject <ADBannerViewDelegate>

+ (ADBannerView *)sharedAdBannerView;

@end
