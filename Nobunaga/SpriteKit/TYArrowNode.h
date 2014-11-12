//
//  TYArrowNode.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/21.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TYArrowNode : SKSpriteNode

@property (nonatomic, strong) SKSpriteNode *arrowNode;

+ (TYArrowNode *)arrowNodeWith:(NSString *)name;
+ (CGPoint)setShootingPoint:(CGFloat)num;

@end
