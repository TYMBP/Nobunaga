//
//  TYUINode.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/09/23.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYUINode.h"

@implementation TYUINode

- (id)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

// retire
- (SKSpriteNode *)makeRetireNode
{
  SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
  label.fontColor = [UIColor whiteColor];
  label.name = kRetireName;
  label.text = @"リタイア";
  label.fontSize = 16;
  
  SKSpriteNode *back = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(label.frame.size.width+10, label.frame.size.height)];
  back.position = CGPointMake(120, -220);
  [back addChild:label];
  label.position = CGPointMake(0, -label.frame.size.height/2+2);
  return back;
}

- (SKSpriteNode *)makeRetireNode2
{
  SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
  label.fontColor = [UIColor whiteColor];
  label.name = kRetireName;
  label.text = @"リタイア";
  label.fontSize = 16;
  
  SKSpriteNode *back = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(label.frame.size.width+10, label.frame.size.height)];
  back.position = CGPointMake(120, -170);
  [back addChild:label];
  label.position = CGPointMake(0, -label.frame.size.height/2+2);
  return back;
}

- (SKLabelNode *)setStageNo
{
  SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
  label.name = kSceneStageName;
  label.text = @"FIRST STAGE";
  label.fontSize = 20;
  label.position = CGPointMake(0, 30);
  return label;
}

- (SKLabelNode *)makeTimeLabel
{
  SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
  label.name = kTimeName;
  label.fontSize = 20;
  label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
  label.position = CGPointMake(80, 210);
  
  return label;
}



@end
