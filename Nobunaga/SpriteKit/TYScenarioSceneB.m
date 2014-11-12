//
//  TYScenarioSceneB.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/09/01.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYScenarioSceneB.h"
#import "TYGamePlayTimeManager.h"
#import <GameKit/GameKit.h>

@implementation TYScenarioSceneB {
  NSInteger _n;
  NSInteger _scene_no;
  NSString *_text;
  NSTimer *_tmA;
  NSTimer *_tmB;
  NSArray *_arry;
  TYGamePlayTimeManager *_sharedManager;
  float _timerCount;
}

- (id)initWithSize:(CGSize)size
{
  if (self = [super initWithSize:size]) {
  
    _arry = @[@"....",
              @"人間五十年",
              @"下天の内をくらぶれば",
              @"夢幻の如くなり",
              @"もはやこの信長が",
              @"世になすべきことは",
              @"ただひとつ",
              @"さらばじゃ！！！"];
    _n = 0;
    _scene_no = 0;
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.baseNode = [SKNode node];
    self.baseNode.name = kBaseNodeName;
    [self addChild:self.baseNode];
    //背景
    SKSpriteNode *back = [SKSpriteNode spriteNodeWithImageNamed:@"Scenario"];
    [self.baseNode addChild:back];
    //セリフフレーム
    SKSpriteNode *serifFrame = [SKSpriteNode spriteNodeWithImageNamed:@"Frame"];
    serifFrame.position = CGPointMake(0, -10);
    serifFrame.name = @"frame";
    [self.baseNode addChild:serifFrame];
    //名前フレーム
    SKSpriteNode *nameFrame = [SKSpriteNode spriteNodeWithImageNamed:@"NamePlate"];
    nameFrame.name = @"nameFrame";
    nameFrame.position = CGPointMake(-100, 50);
    [self.baseNode addChild:nameFrame];
    //セリフテキスト
    self.serifA = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
    self.serifA.fontSize = 20;
    self.serifA.name = @"serif";
    self.serifA.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.serifA.position = CGPointMake(-120, 0);
    [serifFrame addChild:self.serifA];
    
    self.serifB = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
    self.serifB.fontSize = 20;
    self.serifB.name = @"serif";
    self.serifB.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.serifB.position = CGPointMake(-120, -35);
    [serifFrame addChild:self.serifB];
    
    SKLabelNode *skip = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
    skip.fontSize = 20;
    skip.name = @"skip";
    skip.position = CGPointMake(0, -160);
    skip.text = @"SKIP";
    [self.baseNode addChild:skip];
    SKAction *blinkSkip = [SKAction sequence:@[
                                         [SKAction fadeOutWithDuration:0.5],
                                         [SKAction fadeInWithDuration:0.5]]];
    SKAction *blink = [SKAction repeatActionForever:blinkSkip];
    [skip runAction:blink];
    
    //Model
    _sharedManager = [TYGamePlayTimeManager sharedmanager];
    _timerCount = [_sharedManager fetchTime];
//    LOG(@"timerCount %f",_timerCount)
//    float second = fmodf(_timerCount, 60);
//    int minute = _timerCount / 60;
//    NSString *timeTxt = [NSString stringWithFormat:@"%02d:%02.0f", minute, second];
    //
 
    //セリフスタート
    [self serifAnimeStart];
  }
  return self;
}

- (void)serifAnimeStart
{
  [self nobunagaAnime];
  [self serifStart];
}

- (void)nobunagaAnime
{
  SKLabelNode *name = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
  name.fontSize = 14;
  name.name = kSceneNobunagaName;
  name.position = CGPointMake(-100, 45);
  name.text = @"信長";
  [self.baseNode addChild:name];
  SKSpriteNode *nobunaga = [SKSpriteNode spriteNodeWithImageNamed:@"Nobunaga"];
  nobunaga.name = kSceneNobunaga;
  nobunaga.position = CGPointMake(-300, 160);
  [self.baseNode addChild:nobunaga];
  SKAction *action = [SKAction moveToX:0.0f duration:0.3];
  [nobunaga runAction:action];
}

- (SKSpriteNode *)addNextArrow
{
  SKSpriteNode *nextArrow = [SKSpriteNode spriteNodeWithImageNamed:@"NextArrow"];
  nextArrow.name = @"next";
  nextArrow.position = CGPointMake(110, -50);
  SKAction *blink = [SKAction sequence:@[
                                         [SKAction fadeOutWithDuration:0.5],
                                         [SKAction fadeInWithDuration:0.5]]];
  SKAction *blinkForever = [SKAction repeatActionForever:blink];
  [nextArrow runAction:blinkForever];
  return nextArrow;
}

- (void)serifStart
{
  SEL selA;
  selA = @selector(addMessageA:);
  NSMethodSignature *signatureA = [[self class] instanceMethodSignatureForSelector:selA];
  NSInvocation *invocationA = [NSInvocation invocationWithMethodSignature:signatureA];
  [invocationA setTarget:self];
  [invocationA setSelector:selA];
  NSString *serif = [_arry objectAtIndex:_scene_no];
  [invocationA setArgument:(void *)&serif atIndex:2];
  _tmA = [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocationA repeats:YES];
  
}

- (void)addMessageA:(NSString *)serif
{
  if (_n < [serif length]) {
    _n++;
    self.serifA.text = [serif substringToIndex:_n];
  } else {
    [_tmA invalidate];
    _scene_no++;
    if (_scene_no == 3 || _scene_no == 5) {
      SEL selB = @selector(addMessageB:);
      NSMethodSignature *signatureB = [[self class] instanceMethodSignatureForSelector:selB];
      NSInvocation *invocationB = [NSInvocation invocationWithMethodSignature:signatureB];
      [invocationB setTarget:self];
      [invocationB setSelector:selB];
      NSString *serif = [_arry objectAtIndex:_scene_no];
      [invocationB setArgument:(void *)&serif atIndex:2];
      _tmB = [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocationB repeats:YES];
      _n = 0;
      
    } else {
      _n = 0;
      SKSpriteNode *next = [self addNextArrow];
      [self.baseNode addChild:next];
      self.inTapFlag = NO;
    }
  }
}

- (void)addMessageB:(NSString *)serif
{
  if (_n < [serif length]) {
    _n++;
    self.serifB.text = [serif substringToIndex:_n];
  } else {
    [_tmB invalidate];
    _scene_no++;
    _n = 0;
    SKSpriteNode *next = [self addNextArrow];
    [self.baseNode addChild:next];
    self.inTapFlag = NO;
  }
}

//ゲームセンターに送信
- (void)scoreSend
{
  LOG(@"scoreSend %f", _timerCount)
  if ([GKLocalPlayer localPlayer].isAuthenticated) {
  LOG()
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:LEADERBOARD_ID];
    score.value = _timerCount;
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
      if (error) {
        LOG(@"error: %@", error)
      }
    }];
  }
}

//タッチダウン
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (self.gameOverFlag) {
    [_sharedManager updateFlag];
  }
  
  if (self.inTapFlag) {
    return;
  }
  self.inTapFlag = YES;
  
  UITouch *touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInNode:self];
  SKNode *nodeSkip = [self nodeAtPoint:touchPoint];
 
  if ([nodeSkip.name isEqualToString:@"skip"]) {
    _scene_no = 8;
  }
  
  SKNode *node = [self childNodeWithName:kBaseNodeName];
  switch (_scene_no) {
    case 1 :
    case 2 :
    case 3 :
    case 5 :
    {
      SKSpriteNode *arrow = (SKSpriteNode *)[node childNodeWithName:@"next"];
      [arrow removeFromParent];
    
      [self serifStart];
      break;
    }
    case 4 :
    case 6 :
    {
      SKSpriteNode *arrow = (SKSpriteNode *)[node childNodeWithName:@"next"];
      [arrow removeFromParent];
      self.serifB.text = @"";
      [self serifStart];
      break;
    }
    case 7 :
    {
      SKSpriteNode *arrow = (SKSpriteNode *)[node childNodeWithName:@"next"];
      [arrow removeFromParent];
      [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(serifStart) userInfo:nil repeats:NO];
      break;
    }
    case 8 :
    {
      //gameover
      SKSpriteNode *serif = (SKSpriteNode *)[node childNodeWithName:@"scerif"];
      SKSpriteNode *frame = (SKSpriteNode *)[node childNodeWithName:@"frame"];
      SKSpriteNode *name = (SKSpriteNode *)[node childNodeWithName:kSceneNobunagaName];
      SKSpriteNode *arrow = (SKSpriteNode *)[node childNodeWithName:@"next"];
      SKSpriteNode *nobunaga = (SKSpriteNode *)[node childNodeWithName:kSceneNobunaga];
      SKSpriteNode *nameFrame = (SKSpriteNode *)[node childNodeWithName:@"nameFrame"];
      SKSpriteNode *skip = (SKSpriteNode *)[node childNodeWithName:@"skip"];
      
      [serif removeFromParent];
      [frame removeFromParent];
      [name removeFromParent];
      [arrow removeFromParent];
      [nobunaga removeFromParent];
      [nameFrame removeFromParent];
      [skip removeFromParent];
      self.inTapFlag = YES;
      self.gameOverFlag = YES;
      SKLabelNode *gameOver = [self gameOver];
      [self.baseNode addChild:gameOver];
      
      break;
    }
    default:
      break;
  }
}

- (SKLabelNode *)gameOver
{
  SKSpriteNode *fire = [SKSpriteNode spriteNodeWithImageNamed:@"Fire"];
  [self.baseNode addChild:fire];
  SKAction *blinkSkip = [SKAction sequence:@[
                                       [SKAction fadeOutWithDuration:0.8],
                                       [SKAction fadeInWithDuration:0.8]]];
  SKAction *blinkFire = [SKAction repeatActionForever:blinkSkip];
  [fire runAction:blinkFire];
  
  SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
  label.name = kSceneStageName;
  label.text = @"GAME OVER!";
  label.fontSize = 30;
  label.position = CGPointMake(0, 30);
  SKAction *blinkLabel = [SKAction repeatActionForever:blinkSkip];
  [label runAction:blinkLabel];
  
  [self scoreSend];
  
  return label;
}
@end
