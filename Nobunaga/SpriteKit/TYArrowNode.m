//
//  TYArrowNode.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/21.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYArrowNode.h"

@implementation TYArrowNode

+ (TYArrowNode *)arrowNodeWith:(NSString *)name
{
  TYArrowNode *arrow = [TYArrowNode spriteNodeWithImageNamed:name];
  arrow.name = kWeponName;
  arrow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:arrow.size];
  arrow.physicsBody.affectedByGravity = NO;
  
  return arrow;
}

static inline CGFloat skRand(int num)
{
  CGFloat res = arc4random() % num + 1;
  return res;
}
//矢の発射地点
+ (CGPoint)setShootingPoint:(CGFloat)num
{
  CGPoint res;
  CGFloat x, y;
  
  if (num == 1) {
    x = CONST_WD_PLUS;
    if (skRand(2) == 2) {
      y = skRand(284);
    } else {
      y = -(skRand(284));
    }
  } else if (num == 2) {
    y = CONST_HT_MINUS;
    if (skRand(2) == 2) {
      x = skRand(160);
    } else {
      x = -(skRand(160));
    }
  } else {
    x = CONST_WD_MINUS;
    if (skRand(2) == 2) {
      y = skRand(284);
    } else {
      y = -(skRand(284));
    }
  }
  res = CGPointMake(x, y);
  
  return res;
}



@end
