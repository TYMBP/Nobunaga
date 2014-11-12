//
//  TYAppDelegate.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/07/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYAppDelegate.h"
#import "TYViewController.h"
#import "TYGamePlayTimeManager.h"

@implementation TYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  _sharedData = [TYGamePlayTimeManager sharedmanager];
  TYViewController *viewController = [[TYViewController alloc] init];
  self.window.rootViewController = viewController;
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
