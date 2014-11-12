//
//  TYScenarioSceneA.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/27.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYScenarioSceneA.h"
#import "TYGameSceneFirst.h"
#import "TYGameSceneFinal.h"

@implementation TYScenarioSceneA {
  NSInteger _n;
  NSInteger _scene_no;
  NSString *_text;
  NSTimer *_tm;
  NSArray *_arry;
}

- (id)initWithSize:(CGSize)size
{
  if (self = [super initWithSize:size]) {
  
    _arry = @[@"殿…", @"謀反でございます！", @"相手は何者ぞ…", @"桔梗の紋、明智光秀で候", @"......",@"是非に及ばず…"];
    
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
    [self.baseNode addChild:serifFrame];
    //名前フレーム
    SKSpriteNode *nameFrame = [SKSpriteNode spriteNodeWithImageNamed:@"NamePlate"];
    nameFrame.position = CGPointMake(-100, 50);
    [self.baseNode addChild:nameFrame];
    //セリフテキスト
    self.serif = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
    self.serif.fontSize = 20;
    self.serif.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.serif.position = CGPointMake(-120, 0);
    [serifFrame addChild:self.serif];
    
    SKLabelNode *skip = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
    skip.fontSize = 20;
    skip.name = @"skip";
    skip.position = CGPointMake(0, -160);
    skip.text = @"SKIP";
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.5],
                                           [SKAction fadeInWithDuration:0.5]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [skip runAction:blinkForever];
    [self.baseNode addChild:skip];
 
    //セリフスタート
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(serifAnimeStart) userInfo:nil repeats:NO];
//    [self serifAnimeStart];
    
  }
  return self;
}

- (void)serifAnimeStart
{
  [self ranmaruAnime];
  [self serifStart];
}

- (void)ranmaruAnime
{
  SKLabelNode *name = [SKLabelNode labelNodeWithFontNamed:@"HiraKakuProN-W6"];
  name.fontSize = 14;
  name.name = kSceneRanmaruName;
  name.position = CGPointMake(-100, 45);
  name.text = @"蘭丸";
  [self.baseNode addChild:name];
  
  SKSpriteNode *ranmaru = [SKSpriteNode spriteNodeWithImageNamed:@"Ranmaru"];
  ranmaru.name = kSceneRanmaru;
  ranmaru.position = CGPointMake(-300, 160);
  [self.baseNode addChild:ranmaru];
  SKAction *action = [SKAction moveToX:0.0f duration:0.3];
  [ranmaru runAction:action];
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
//  _tm = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(addMessage) userInfo:nil repeats:YES];
  SEL sel = @selector(addMessage:);
  NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:sel];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
  [invocation setTarget:self];
  [invocation setSelector:sel];
  NSString *serif = [_arry objectAtIndex:_scene_no];
  [invocation setArgument:(void *)&serif atIndex:2];
  _tm = [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:YES];
}

- (void)addMessage:(NSString *)serif
{
  if (_n < [serif length]) {
//    [_tm isValid];
    _n++;
    self.serif.text = [serif substringToIndex:_n];
  } else {
    [_tm invalidate];
    _scene_no++;
    _n = 0;
    SKSpriteNode *next = [self addNextArrow];
    [self.baseNode addChild:next];
    self.inTapFlag = NO;
  }
}

//タッチダウン
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  
  if (self.inTapFlag) {
    return;
  }
  self.inTapFlag = YES;
  
  UITouch *touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInNode:self];
  SKNode *nodeSkip = [self nodeAtPoint:touchPoint];
 
  if ([nodeSkip.name isEqualToString:@"skip"]) {
    LOG()
    TYGameSceneFirst *first = [[TYGameSceneFirst alloc] initWithSize:self.frame.size];
    SKTransition *next = [SKTransition crossFadeWithDuration:1];
    [self.view presentScene:first transition:next];
    //dev
//    TYGameSceneFinal *final = [[TYGameSceneFinal alloc] initWithSize:self.frame.size];
//    [self.view presentScene:final transition:next];
  }
  
  if (_scene_no == 6) {
    TYGameSceneFirst *first = [[TYGameSceneFirst alloc] initWithSize:self.frame.size];
    SKTransition *next = [SKTransition crossFadeWithDuration:1];
    [self.view presentScene:first transition:next];
  }
  SKNode *node = [self childNodeWithName:kBaseNodeName];
  switch (_scene_no) {
    case 1 :
      [self serifStart];
      break;
    case 3 :
    {
      SKSpriteNode *img = (SKSpriteNode *)[node childNodeWithName:kSceneNobunaga];
      [img removeFromParent];
      SKLabelNode *name = (SKLabelNode *)[node childNodeWithName:kSceneNobunagaName];
      [name removeFromParent];
      SKLabelNode *next = (SKLabelNode *)[node childNodeWithName:@"next"];
      [next removeFromParent];
      [self ranmaruAnime];
      [self serifStart];
      break;
    }
    case 2 :
    case 4 :
    {
      SKSpriteNode *img = (SKSpriteNode *)[node childNodeWithName:kSceneRanmaru];
      [img removeFromParent];
      SKLabelNode *name = (SKLabelNode *)[node childNodeWithName:kSceneRanmaruName];
      [name removeFromParent];
      SKLabelNode *next = (SKLabelNode *)[node childNodeWithName:@"next"];
      [next removeFromParent];
      [self nobunagaAnime];
      [self serifStart];
      break;
    }
    case 5 :
    {
      [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(serifStart) userInfo:nil repeats:NO];
//      [self serifStart];
      break;
    }
    default:
      break;
  }
}

@end
