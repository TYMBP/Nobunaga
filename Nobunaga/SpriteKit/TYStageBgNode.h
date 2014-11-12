//
//  TYStageBgNode.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/09/27.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void (^StageFinishBlocks)();

@interface TYStageBgNode : SKSpriteNode

@property (nonatomic, assign) CGFloat animeSpeed;
@property (nonatomic, strong) SKTextureAtlas *textureAtlas;

+ (TYStageBgNode *)StageBgNodeWith:(NSString *)name TextureAtlas:(SKTextureAtlas *)textureAtlas;
+ (TYStageBgNode *)StageBg2NodeWith:(NSString *)name TextureAtlas:(SKTextureAtlas *)textureAtlas;
- (void)clear:(StageFinishBlocks)callback;
- (void)clear2:(StageFinishBlocks)callback;

@end
