//
//  TYCharactorNode.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
  kCharaDirectionDown,
  kCharaDirectionLeft,
  kCharaDirectionUp,
  kCharaDirectionRight,
} CharaDirection;

typedef void (^SpearFinishBlocks)(CGFloat angle);

@interface TYCharactorNode : SKSpriteNode
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat velecity;
@property (nonatomic, assign) CGFloat animeSpeed;
@property (nonatomic, assign) CGFloat hp;
@property (nonatomic, assign) CharaDirection charaDirection;
@property (nonatomic, assign) BOOL inTextureAnime;
@property (nonatomic, assign) BOOL inShootAnime;
@property (nonatomic, assign) BOOL inShootFlag;
@property (nonatomic, assign) BOOL isGetDamage;
@property (nonatomic, strong) SKTextureAtlas *textureAtlas;


+ (TYCharactorNode *)charactorNodeWith:(NSString *)name TextureAtlas:(SKTextureAtlas *)textureAtlas;
+ (CharaDirection)angleToDirection:(CGFloat)direction;
- (void)setAngle:(CGFloat)angle velocity:(CGFloat)velocity;
- (void)stop;
- (void)update;
- (void)spear:(SpearFinishBlocks)response;
- (void)freeze;
@end
