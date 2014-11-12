//
//  TYScenarioSceneA.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/27.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TYScenarioSceneA : SKScene

@property (strong, nonatomic) SKNode *baseNode;
@property (strong, nonatomic) SKLabelNode *serif;
@property (strong, nonatomic) NSString *textA;
@property (nonatomic, assign) BOOL inTapFlag;
@end
