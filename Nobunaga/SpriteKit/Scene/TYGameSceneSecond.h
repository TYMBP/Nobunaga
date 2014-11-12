//
//  TYGameSceneSecond.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/20.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TYCharactorNode.h"
#import "TYEnemyNode.h"
#import "TYArrowNode.h"
#import "TYUINode.h"
#import "TYStageBgNode.h"

@interface TYGameSceneSecond : SKScene <SKPhysicsContactDelegate>
@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) SKNode *baseNode;
@property (assign, nonatomic) CGSize mapSize;
@property (strong, nonatomic) TYCharactorNode *playerNode;
@property (assign, nonatomic) BOOL attackFlg;
@property (assign, nonatomic) BOOL addDataFlg;
@property (assign, nonatomic) BOOL screenFlg;
@property (strong, nonatomic) TYUINode *UINode;
@property (strong, nonatomic) TYStageBgNode *bg;

@end
