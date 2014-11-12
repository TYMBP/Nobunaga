//
//  TYGameView.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TYGameSceneFirst.h"
#import "TYScenarioSceneA.h"

@interface TYGameView : SKView
@property (weak, nonatomic) id delegate;
- (void)setUpGameView;
- (void)switchingGameScene;
@end
