//
//  TYEnemyNode.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/20.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
  kEnemyDirectionDown,
  kEnemyDirectionLeft,
  kEnemyDirectionUp,
  kEnemyDirectionRight,
} EnemyDirection;


@interface TYEnemyNode : SKSpriteNode
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, assign) CGFloat animeSpeed;
@property (nonatomic, assign) CGFloat hp;
@property (nonatomic, assign) EnemyDirection enemyDirection;
@property (nonatomic, assign) BOOL inTextureAnime;
@property (nonatomic, assign) BOOL inShootAnime;
@property (nonatomic,assign) BOOL isGetDamage;
@property (nonatomic, strong) SKTextureAtlas *enumyAtlas;

+ (TYEnemyNode *)enemyNodeWith:(NSString *)name TextureAtlas:(SKTextureAtlas *)textureAtlas;
+ (EnemyDirection)angleToDirection:(CGFloat)direction;
- (void)setAngle:(CGFloat)angle Velocity:(CGFloat)velocity;
- (void)stop;
- (void)update;

@end
