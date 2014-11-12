//
//  TYGameView.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYGameView.h"

//開発用
#import "TYScenarioSceneB.h"

@implementation TYGameView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setUpGameView];
  }
  return self;
}

- (void)setUpGameView
{
  [self switchingGameScene];
}

- (void)switchingGameScene
{
  TYScenarioSceneA *scenario = [[TYScenarioSceneA alloc] initWithSize:self.bounds.size];
  scenario.scaleMode = SKSceneScaleModeAspectFill;
  [self presentScene:scenario];

  //開発用
//  TYScenarioSceneB *scenario = [[TYScenarioSceneB alloc] initWithSize:self.bounds.size];
//  scenario.scaleMode = SKSceneScaleModeAspectFill;
//  [self presentScene:scenario];
  
//  TYGameSceneFirst *scene = [[TYGameSceneFirst alloc] initWithSize:self.bounds.size];
//  scene.scaleMode = SKSceneScaleModeAspectFill;
//  [self presentScene:scene];
}

@end
