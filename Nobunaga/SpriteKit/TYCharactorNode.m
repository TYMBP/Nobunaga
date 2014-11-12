//
//  TYCharactorNode.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYCharactorNode.h"

@implementation TYCharactorNode

+ (TYCharactorNode *)charactorNodeWith:(NSString *)name TextureAtlas:(SKTextureAtlas *)textureAtlas
{

  //プレイヤーノード
  NSString *texname = [NSString stringWithFormat:@"%@_down1", name];
  SKTexture *texture = [textureAtlas textureNamed:texname];
  TYCharactorNode *charaNode = [TYCharactorNode spriteNodeWithTexture:texture];
  charaNode.textureAtlas = textureAtlas;
  charaNode.name = name;
  charaNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:charaNode.size.width/2];
  charaNode.physicsBody.affectedByGravity = NO; //重力適用なし
  charaNode.physicsBody.allowsRotation = NO; //衝突による角度変更なし
  charaNode.physicsBody.linearDamping = 1.0; //空気抵抗
  [charaNode setAngle:M_PI velocity:0];
  charaNode.animeSpeed = 0.1;
  return charaNode;
}

+ (CharaDirection)angleToDirection:(CGFloat)direction
{
//  LOG(@"direction %f", direction)
  CharaDirection res;
  //ラジアンから弧度法に直す
  CGFloat r = direction * 180 / M_PI;
  if (r >= -135 && -45 >r) {
    res = kCharaDirectionRight; //右
  } else if (r >= -45 && 45 > r) {
    res = kCharaDirectionUp; //上
  } else if (r >= 45 && 135 > r) {
    res = kCharaDirectionLeft;
  } else {
    res = kCharaDirectionDown;
  }
  return res;
}

- (void)setAngle:(CGFloat)angle velocity:(CGFloat)velocity
{
  if (self.inShootAnime) {
    return;
  }
  self.angle = angle;
  if (velocity == 0) {
    [self stop]; //停止
  } else {
    CharaDirection dirction = [TYCharactorNode angleToDirection:_angle];
    if (self.charaDirection != dirction || (_velecity == 0 && velocity != 0)) {
      self.charaDirection = dirction;
    }
  }
  self.velecity = velocity;
}

- (void)stop
{
  if (self.inShootAnime) {
    return;
  }
  _velecity = 0;
  NSString *direction;
  if (_charaDirection == kCharaDirectionRight) {
    direction = @"right"; //右
  } else if (_charaDirection == kCharaDirectionUp) {
    direction = @"up"; //上
  } else if (_charaDirection == kCharaDirectionLeft) {
    direction = @"left"; //左
  } else {
    direction = @"down"; //下
  }
  //停止
  self.inTextureAnime = NO;
  [self removeActionForKey:@"charaMove"];
  
  NSString *texname = [NSString stringWithFormat:@"%@_%@1", self.name, direction];
  SKTexture *texture = [self.textureAtlas textureNamed:texname];
  self.texture = texture;
}

- (void)update
{
  if (self.inShootAnime) {
    return;
  }
  //角度からベクトルを求める
  CGFloat x = sin(_angle) * _velecity;
  CGFloat y = cos(_angle) * _velecity;
  //ベクトルを加える
  self.physicsBody.velocity = CGVectorMake(-x, y);
}

//動作設定
- (void)setCharaDirection:(CharaDirection)charaDirection
{
  //テクスチャーアニメーション停止中か、異なる設定の場合
  if (self.inTextureAnime == NO || _charaDirection != charaDirection) {
    _charaDirection = charaDirection;
    SKAction *action = nil;
    NSString *direction;
    if (charaDirection == kCharaDirectionRight) {
      direction = @"right";
    } else if (charaDirection == kCharaDirectionUp) {
      direction = @"up";
    } else if (charaDirection == kCharaDirectionLeft) {
      direction = @"left";
    } else {
      direction = @"down";
    }
    NSArray *ary = @[
                     [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@_%@1", self.name, direction]],
                     [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@_%@2", self.name, direction]],
                     [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@_%@3", self.name, direction]]];
    action = [SKAction animateWithTextures:ary timePerFrame:_animeSpeed resize:NO restore:NO];
  
    self.inTextureAnime = YES;
    [self runAction:[SKAction repeatActionForever:action] withKey:@"charaMove"];
  }
}

- (void)spear:(SpearFinishBlocks)response
{
  if (self.inShootAnime) {
    return;
  }
  [self stop];
  self.inShootFlag = YES;
  self.inShootAnime = YES;
  CGFloat retAngle = 0;
  NSString *direction;
  if (_charaDirection == kCharaDirectionRight) {
    direction = @"right";
    retAngle = -(M_PI/2);
  } else if (_charaDirection == kCharaDirectionUp) {
    direction = @"up";
    retAngle = 0;
  } else if (_charaDirection == kCharaDirectionLeft) {
    direction = @"left";
    retAngle = M_PI/2;
  } else {
    direction = @"down";
    retAngle = M_PI;
  }
  NSArray *ary = @[
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@_%@1", self.name, direction]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"attack_%@1", direction]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"attack_%@2", direction]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"attack_%@1", direction]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"attack_%@2", direction]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"attack_%@1", direction]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"attack_%@2", direction]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"attack_%@1", direction]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"attack_%@2", direction]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@_%@1", self.name, direction]]];
  SKAction *action = [SKAction animateWithTextures:ary timePerFrame:0.1 resize:NO restore:NO];
  [self runAction:action completion:^{
    self.inShootFlag = NO;
    self.inShootAnime = NO;
    if (response) {
      response(retAngle);
    }
  }];
}

- (void)setHp:(CGFloat)hp
{
  _hp = hp;
  if (_hp > 0) {
    _hp = 0;
  }
}

//ダメージフラグ
- (void)setIsGetDamage:(BOOL)isGetDamage
{
  _isGetDamage = isGetDamage;
  NSString *direction;
  if (_charaDirection == kCharaDirectionRight) {
    direction = @"right";
  } else if (_charaDirection == kCharaDirectionUp) {
    direction = @"up";
  } else if (_charaDirection == kCharaDirectionLeft) {
    direction = @"left";
  } else {
    direction = @"down";
  }
}

//ダメージフリーズ
- (void)freeze
{
  if (self.inShootAnime) {
    return;
  }
  [self stop];
  
  self.inShootAnime = YES;
  CGFloat retAngle = 0;
  NSString *direction;
  if (_charaDirection == kCharaDirectionRight) {
    direction = @"right";
    retAngle = -(M_PI/2);
  } else if (_charaDirection == kCharaDirectionUp) {
    direction = @"up";
    retAngle = 0;
  } else if (_charaDirection == kCharaDirectionLeft) {
    direction = @"left";
    retAngle = M_PI/2;
  } else {
    direction = @"down";
    retAngle = M_PI;
  }
  NSArray *ary = @[
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"%@_%@1", self.name, direction]],
                   [_textureAtlas textureNamed:[NSString stringWithFormat:@"damage"]]];
  
  SKAction *action = [SKAction animateWithTextures:ary timePerFrame:0.1 resize:YES restore:NO];
  
  [self runAction:action completion:^{
    //フリーズ状態を秒
    NSTimer *tm;
    tm = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(freezeLift) userInfo:nil repeats:NO];
  }];
  
}

//フリーズを解除
- (void)freezeLift
{
  self.inShootAnime = NO;
}

@end
