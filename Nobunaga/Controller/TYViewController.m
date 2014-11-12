//
//  TYViewController.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYViewController.h"

@implementation TYViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
  self.vcntManager = [[TYViewControllerManager alloc] init];
  [self.vcntManager switchingTitleViewController:self];
}

@end
