//
//  TYGameSceneFinal.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/09/01.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYGameSceneFinal.h"
#import "TYGameView.h"
#import "TYGamePlayTimeManager.h"
#import "TYScenarioSceneB.h"

@implementation TYGameSceneFinal {
  CGPoint _touchPoint;
  SKLabelNode *_timeLabel;
  float _timerCount;
  NSTimer *timer;
  TYGamePlayTimeManager *_gamePlayTime;
}

- (id)initWithSize:(CGSize)size
{
  if (self = [super initWithSize:size]) {
    self.UINode = [[TYUINode alloc] init];
    //引き継ぎタイムラベル
    _gamePlayTime = [TYGamePlayTimeManager sharedmanager];
    _timerCount = [_gamePlayTime fetchTime];
    LOG(@"timeCount %f", _timerCount)
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.baseNode = [SKNode node];
    self.baseNode.name = kBaseNodeName;
    [self addChild:self.baseNode];
    
    //背景
    CGRect screen = [[UIScreen mainScreen] applicationFrame];
    if (screen.size.height >= CONST_SCREEN) {
      self.screenFlg = YES;
      SKTextureAtlas *stageBg = [SKTextureAtlas atlasNamed:@"scene"];
      self.bg = [TYStageBgNode StageBgNodeWith:@"bg" TextureAtlas:stageBg];
      [self.baseNode addChild:self.bg];
      //リタイア
      SKSpriteNode *retire = [_UINode makeRetireNode];
      retire.name = kRetireName;
      [self.baseNode addChild:retire];
    } else {
      self.screenFlg = NO;
      SKTextureAtlas *stageBg = [SKTextureAtlas atlasNamed:@"scene"];
      self.bg = [TYStageBgNode StageBg2NodeWith:@"bg" TextureAtlas:stageBg];
      [self.baseNode addChild:self.bg];
      //リタイア
      SKSpriteNode *retire = [_UINode makeRetireNode2];
      retire.name = kRetireName;
      [self.baseNode addChild:retire];
    }
    
    SKTextureAtlas *playerAtlas = [SKTextureAtlas atlasNamed:@"nobunaga"];
    self.playerNode = [TYCharactorNode charactorNodeWith:kPlayerName TextureAtlas:playerAtlas];
    [self.baseNode addChild:self.playerNode];
    self.playerNode.position = CGPointMake(0, 0);
    self.playerNode.physicsBody.categoryBitMask = playerCategory;
    self.playerNode.physicsBody.collisionBitMask = enemyCategory|frameCategory;
    self.playerNode.physicsBody.contactTestBitMask = frameCategory;
    
    SKNode *frameNode = [SKNode node];
    frameNode.name = kFrameName;
    [self.baseNode addChild:frameNode];
    frameNode.position = CGPointMake(0, 0);
    frameNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-(self.frame.size.width/2), -(self.frame.size.height/2), self.frame.size.width, self.frame.size.height)];
    frameNode.physicsBody.categoryBitMask = frameCategory;
    frameNode.physicsBody.collisionBitMask = playerCategory;
    
    //接触デリゲート
    self.physicsWorld.contactDelegate = self;
    
    //敵AI
    static CGPoint enemyPos[10] = {
      {-100, 200},{-30, 200},{40,200},{110,200},
      {-100, -200},{-30, -200},{40,-200},{110,-200},
      {-100, 0},{100, 0},
    };
    SKTextureAtlas *enemyAtlas = [SKTextureAtlas atlasNamed:@"enemy"];
    for (int i=0; i < 10; i++) {
      TYEnemyNode *enemy = [TYEnemyNode enemyNodeWith:kEnemyName TextureAtlas:enemyAtlas];
      [self.baseNode addChild:enemy];
      enemy.hp = 1;
      enemy.position = enemyPos[i];
      enemy.physicsBody.categoryBitMask = enemyCategory;
      enemy.physicsBody.collisionBitMask = playerCategory|enemyCategory|frameCategory;
      enemy.physicsBody.contactTestBitMask = playerCategory;
    }
    
    //矢
    SKAction *attackArrow = [SKAction sequence:@[
                                                 [SKAction performSelector:@selector(addArrow) onTarget:self],
                                                 [SKAction waitForDuration:0.5]
                                                 ]];
    [self runAction:[SKAction repeatActionForever:attackArrow]];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timer)
                                           userInfo:nil
                                            repeats:YES];
    
    _timeLabel = [self.UINode makeTimeLabel];
    if (!self.screenFlg) {
      _timeLabel.position = CGPointMake(80, 170);
    }
    [self.baseNode addChild:_timeLabel];
    //リタイア
    SKLabelNode *stage = [self setStageNo];
    [self.baseNode addChild:stage];
    SKAction *blink = [SKAction fadeOutWithDuration:0.5];
    [stage runAction:blink];
    
  }
  return self;
}

- (SKLabelNode *)setStageNo
{
  SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
  label.name = kSceneStageName;
  label.text = @"FINAL STAGE";
  label.fontSize = 20;
  label.position = CGPointMake(0, 30);
  return label;
}

- (void)timer
{
  _timerCount = _timerCount + 1.0f;
  float second = fmodf(_timerCount, 60);
  int minute = _timerCount / 60;
  NSString *timeTxt = [NSString stringWithFormat:@"%02d:%02.0f", minute, second];
  _timeLabel.text = timeTxt;
}

//リタイアアラート
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) {
    LOG(@"no")
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timer)
                                           userInfo:nil
                                            repeats:YES];
  } else if (buttonIndex == 1) {
    LOG(@"yes")
    NSNotification *nc = [NSNotification notificationWithName:@"retire" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:nc];
  }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
  NSString *bodyNameA = contact.bodyA.node.name;
  NSString *bodyNameB = contact.bodyB.node.name;
  
  if (([bodyNameA isEqualToString:kFrameName]) && [bodyNameB isEqualToString:kPlayerName]) {
    SKNode *node = [self childNodeWithName:kBaseNodeName];
    SKSpriteNode *charactor = (SKSpriteNode *)[node childNodeWithName:kPlayerName];
    CGFloat posi = charactor.position.y;
    //敵が０なら
    if (![node childNodeWithName:kEnemyName]) {
      //画面最上部についたら次のステージへ
      if (self.screenFlg && posi > 230) {
        [timer invalidate];
        if (!self.addDataFlg) {
          self.addDataFlg = YES;
          [_gamePlayTime updateData:_timerCount];
        }
        [self.bg clear:^{
          TYScenarioSceneB *scenario = [[TYScenarioSceneB alloc] initWithSize:self.frame.size];
          SKTransition *next = [SKTransition crossFadeWithDuration:1];
          [self.view presentScene:scenario transition:next];
        }];
      } else {
        [timer invalidate];
        if (!self.addDataFlg) {
          self.addDataFlg = YES;
          [_gamePlayTime updateData:_timerCount];
        }
        [self.bg clear2:^{
          TYScenarioSceneB *scenario = [[TYScenarioSceneB alloc] initWithSize:self.frame.size];
          SKTransition *next = [SKTransition crossFadeWithDuration:1];
          [self.view presentScene:scenario transition:next];
        }];
      }
    }
  } else if ([bodyNameA isEqualToString:kPlayerName] && [bodyNameB isEqualToString:kEnemyName]) {
    if (self.playerNode.inShootFlag) {
      if (self.playerNode.inShootAnime) {
        TYEnemyNode *enemy;
        enemy = (TYEnemyNode *)contact.bodyB.node;
        enemy.hp -= contact.collisionImpulse;
        if (enemy.hp <= 0) {
          enemy.physicsBody.collisionBitMask = 0;
          NSArray *ary = @[
                           [SKAction fadeAlphaBy:0 duration:0.25],
                           [SKAction removeFromParent]];
          [enemy runAction:[SKAction sequence:ary]];
        }
      }
    }
  } else if ([bodyNameA isEqualToString:kWeponName] && [bodyNameB isEqualToString:kPlayerName]) { //矢が当たる
    TYArrowNode *arrow;
    arrow = (TYArrowNode *)contact.bodyA.node;
    NSArray *ary = @[
                     [SKAction fadeAlphaBy:0 duration:0.1],
                     [SKAction removeFromParent]];
    [arrow runAction:[SKAction sequence:ary]];
    [self.playerNode freeze];
    
  }
}

- (void)didSimulatePhysics
{
  [self.playerNode update];
 
  //敵AI
  [self.baseNode enumerateChildNodesWithName:kEnemyName usingBlock:^(SKNode *node, BOOL *stop){
    TYEnemyNode *enemy = (TYEnemyNode *)node;
    if (enemy.isGetDamage == NO) {
      CGPoint dogPos = self.playerNode.position;
      CGPoint enemyPos = enemy.position;
      //距離判定
      if (YES) {
        //プレイヤー方向に移動
        CGFloat angle = -(atan2f(dogPos.x-enemyPos.x, dogPos.y-enemyPos.y));
        if (enemy.velocity == 0) {
          enemy.velocity = 30;
          [enemy setAngle:angle Velocity:enemy.velocity];
        } else {
          EnemyDirection dirction = [TYEnemyNode angleToDirection:angle];
          enemy.enemyDirection = dirction;
          enemy.angle = angle;
        }
      } else if (enemy.velocity != 0) {
        [enemy stop];
      }
      [enemy update];
    }
  }];
}

//タッチダウン
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  _touchPoint = [touch locationInNode:self];
  NSUInteger tapNum = [touch tapCount];
  if (tapNum > 1) {
    //攻撃
    [self.playerNode spear:^(CGFloat angle){
      
    }];
  }
  SKNode *node = [self nodeAtPoint:_touchPoint];
  if ([node.name isEqualToString:kRetireName]) {
    [timer invalidate];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRetireTitle message:kRetaireDesc delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
  }
}

//タッチムーブ
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (self.playerNode.isGetDamage == NO) {
    //タッチダウンした位置を得る
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    //タッチダウンした位置からの距離を求め、それを速度とする
    double x = fabs(_touchPoint.x-location.x);
    double y = fabs(_touchPoint.y-location.y);
    CGFloat velocity = sqrt((x*x)*(y*y)) * 2;
    if (velocity < 30) {
      velocity = 30; //微速
    } else if (velocity > 100) {
      velocity = 100; //最高速固定
    }
    //タッチダウンした位置からプレイヤーの進行方向を求める
    CGFloat angle = -(atan2f(location.x-_touchPoint.x, location.y-_touchPoint.y));
    //プレイヤーキャラにアングルと速度を設定
    [self.playerNode setAngle:angle velocity:velocity];
  }
}

//タッチアップ
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.playerNode stop];
}

- (void)addArrow
{
  TYArrowNode *arrow = [TYArrowNode arrowNodeWith:kWeponName];
  CGFloat num = arc4random() % 3 + 1;//方向を決める
  CGPoint point = [TYArrowNode setShootingPoint:num];
  [self.baseNode addChild:arrow];
  SKNode *base = [self childNodeWithName:kBaseNodeName];
  SKSpriteNode *player = (SKSpriteNode *)[base childNodeWithName:kPlayerName];
  CGPoint playerPoint = player.position;
  
  CGFloat radian = -(atan2f(-(point.x-playerPoint.x), -(point.y-playerPoint.y)));
  CGFloat x = sin(radian);
  CGFloat y = cos(radian);
  arrow.physicsBody.velocity = CGVectorMake(-(100*x), (100*y));
  arrow.zRotation = radian;
  
  arrow.position = point;
  arrow.physicsBody.categoryBitMask = weponCategory;
  arrow.physicsBody.contactTestBitMask = playerCategory;
  arrow.physicsBody.collisionBitMask = playerCategory;
  
}

@end