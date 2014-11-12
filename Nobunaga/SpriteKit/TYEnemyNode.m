//
//  TYEnemyNode.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/20.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYEnemyNode.h"

@implementation TYEnemyNode

+ (TYEnemyNode *)enemyNodeWith:(NSString *)name TextureAtlas:(SKTextureAtlas *)textureAtlas
{
  NSString *enemyName = [NSString stringWithFormat:@"%@_down1", name];
  SKTexture *texture = [textureAtlas textureNamed:enemyName];
  TYEnemyNode *enemyNode = [TYEnemyNode spriteNodeWithTexture:texture];
  enemyNode.enumyAtlas = textureAtlas;
  enemyNode.name = name;
  enemyNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemyNode.size.width/2];
  enemyNode.physicsBody.affectedByGravity = NO; //重力衝突なし
  enemyNode.physicsBody.allowsRotation = NO; //衝突による角度変更なし
  enemyNode.physicsBody.linearDamping = 1.0; //空気抵抗
  [enemyNode setAngle:M_PI Velocity:0];
  enemyNode.animeSpeed = 0.1;
  return enemyNode;
}

+ (EnemyDirection)angleToDirection:(CGFloat)direction
{
  EnemyDirection res;
  CGFloat r = direction *180 / M_PI;
  if (r >= -135 && -45 > r) {
    res = kEnemyDirectionRight;
  } else if (r >= -45 && 45 > r) {
    res = kEnemyDirectionUp;
  } else if (r >= 45 && 135 > r) {
    res = kEnemyDirectionLeft;
  } else {
    res = kEnemyDirectionDown;
  }
  return res;
}

- (void)setAngle:(CGFloat)angle Velocity:(CGFloat)velocity
{
  if (self.inShootAnime) {
    return;
  }
  self.angle = angle;
  if (velocity == 0) {
    [self stop];
  } else {
    EnemyDirection dirction = [TYEnemyNode angleToDirection:_angle];
    if (self.enemyDirection != dirction || (_velocity == 0 && velocity != 0)) {
      self.enemyDirection = dirction;
    }
  }
  self.velocity = velocity;
}

- (void)stop
{
  if (self.inShootAnime) {
    return;
  }
  _velocity = 0;
  NSString *direction;
  if (_enemyDirection == kEnemyDirectionRight) {
    direction = @"right";
  } else if (_enemyDirection == kEnemyDirectionUp) {
    direction = @"up";
  } else if (_enemyDirection == kEnemyDirectionLeft) {
    direction = @"left";
  } else {
    direction = @"down";
  }
  //
  self.inTextureAnime = NO;
  [self removeActionForKey:@"enemyMove"];
  
  NSString *texname = [NSString stringWithFormat:@"%@_%@1", self.name, direction];
  SKTexture *texture = [self.enumyAtlas textureNamed:texname];
  self.texture = texture;
}

- (void)update
{
  if (self.inShootAnime) {
    return;
  }
  CGFloat x = sin(_angle) * _velocity;
  CGFloat y = cos(_angle) * _velocity;
  
  self.physicsBody.velocity = CGVectorMake(-x, y);

}

- (void)setEnemyDirection:(EnemyDirection)enemyDirection
{
  if (self.inTextureAnime == NO || _enemyDirection != enemyDirection) {
    _enemyDirection = enemyDirection;
    SKAction *action = nil;
    NSString *direction;
    if (enemyDirection == kEnemyDirectionRight) {
      direction = @"right";
    } else if (enemyDirection == kEnemyDirectionUp) {
      direction = @"up";
    } else if (enemyDirection == kEnemyDirectionLeft) {
      direction = @"left";
    } else {
      direction = @"down";
    }
    NSArray *ary = @[
                     [_enumyAtlas textureNamed:[NSString stringWithFormat:@"%@_%@1", self.name, direction]],
                     [_enumyAtlas textureNamed:[NSString stringWithFormat:@"%@_%@2", self.name, direction]],
                     [_enumyAtlas textureNamed:[NSString stringWithFormat:@"%@_%@3", self.name, direction]]];
    action = [SKAction animateWithTextures:ary timePerFrame:_animeSpeed resize:YES restore:YES];
    
    self.inTextureAnime = YES;
    [self runAction:[SKAction repeatActionForever:action] withKey:@"enemyMove"];
  }
}

@end
