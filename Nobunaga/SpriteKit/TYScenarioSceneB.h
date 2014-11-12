//
//  TYScenarioSceneB.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/09/01.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TYScenarioSceneB : SKScene
@property (strong, nonatomic) SKNode *baseNode;
@property (strong, nonatomic) SKLabelNode *serifA;
@property (strong, nonatomic) SKLabelNode *serifB;
@property (strong, nonatomic) NSString *textA;
@property (nonatomic, assign) BOOL inTapFlag;
@property (nonatomic, assign) BOOL gameOverFlag;

@end
