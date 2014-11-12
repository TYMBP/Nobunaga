//
//  TYStageBgNode.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/09/27.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYStageBgNode.h"

@implementation TYStageBgNode

+ (TYStageBgNode *)StageBgNodeWith:(NSString *)name TextureAtlas:(SKTextureAtlas *)textureAtlas
{
  NSString *texname = [NSString stringWithFormat:@"%@1", name];
  SKTexture *texture = [textureAtlas textureNamed:texname];
  TYStageBgNode *bgNode = [TYStageBgNode spriteNodeWithTexture:texture];
  bgNode.textureAtlas = textureAtlas;
  bgNode.name = kStageBgName;
  bgNode.physicsBody.affectedByGravity = NO;
  bgNode.physicsBody.allowsRotation = NO;
  bgNode.animeSpeed = 0.2;
  
  return bgNode;
}
+ (TYStageBgNode *)StageBg2NodeWith:(NSString *)name TextureAtlas:(SKTextureAtlas *)textureAtlas
{
  NSString *texname = [NSString stringWithFormat:@"%@5", name];
  SKTexture *texture = [textureAtlas textureNamed:texname];
  TYStageBgNode *bgNode = [TYStageBgNode spriteNodeWithTexture:texture];
  bgNode.textureAtlas = textureAtlas;
  bgNode.name = kStageBgName;
  bgNode.physicsBody.affectedByGravity = NO;
  bgNode.physicsBody.allowsRotation = NO;
  bgNode.animeSpeed = 0.2;
  
  return bgNode;
}

- (void)clear:(StageFinishBlocks)callback
{
  NSString *bg = @"bg";
  NSArray *ary = @[
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@1", bg]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@2", bg]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@3", bg]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@4", bg]]];
  SKAction *action = [SKAction animateWithTextures:ary timePerFrame:_animeSpeed resize:NO restore:NO];

  [self runAction:action completion:^{
    if (callback) {
      LOG()
      callback();
    }
    
  }];
  
}

- (void)clear2:(StageFinishBlocks)callback
{
  NSString *bg = @"bg";
  NSArray *ary = @[
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@5", bg]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@6", bg]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@7", bg]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@8", bg]]];
  SKAction *action = [SKAction animateWithTextures:ary timePerFrame:_animeSpeed resize:NO restore:NO];

  [self runAction:action completion:^{
    if (callback) {
      LOG()
      callback();
    }
    
  }];
  
}

@end
