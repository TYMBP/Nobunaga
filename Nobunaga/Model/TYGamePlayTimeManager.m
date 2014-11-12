//
//  TYGamePlayTimeManager.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/08/24.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYGamePlayTimeManager.h"
#import "PlayTime.h"
#import "TYGameOver.h"

@implementation TYGamePlayTimeManager {
  PlayTime *_dataObject;
  TYGameOver *_gameOver;
}

static TYGamePlayTimeManager *sharedInstance = nil;

+ (TYGamePlayTimeManager *)sharedmanager
{
  @synchronized(self) {
    if (sharedInstance == nil) {
      LOG()
      sharedInstance = [[self alloc] init];
    }
  }
  return sharedInstance;
}

- (id)init
{
  self = [super init];
  if (self) {
    LOG()
    [self loadManagedObjectContext];
    [self setGameOverFlag];
  }
  return self;
}

- (void)loadManagedObjectContext
{
  if (_context != nil)
    return;
  NSPersistentStoreCoordinator *aCoodinator = [self coordinator];
  if (aCoodinator != nil) {
    _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:aCoodinator];
  }
}

- (NSPersistentStoreCoordinator *)coordinator
{
  if (_coordinator != nil) {
    return _coordinator;
  }
  NSURL* modelURL = [NSURL fileURLWithPath:[NSFileManager defaultManager].currentDirectoryPath];
  modelURL = [modelURL URLByAppendingPathComponent:@"TYGamePlayTimeData.momd"];
// SQLiteパターン
//  NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//  _storeURL = [NSURL fileURLWithPath:[directory stringByAppendingPathComponent:@"TYGamePlayTimeData.sqlite"]];
//  LOG("storeURL %@", _storeURL)
  NSError *error = nil;
  _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  
  if (![_coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:_storeURL options:nil error:&error]) {
    abort();
  }
  return _coordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"TYGamePlayTimeData" ofType:@"momd"];
  NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  
  return _managedObjectModel;
}

//タイム保存
- (void)addData:(float)time
{
  LOG("%f", time)
  _dataObject = (PlayTime *)[NSEntityDescription insertNewObjectForEntityForName:@"PlayTime" inManagedObjectContext:_context];
  
  if (_dataObject == nil) {
    return;
  }
  [_dataObject setValue:[NSNumber numberWithFloat:time] forKey:@"time"];
  
  NSError *error = nil;
  if (![_context save:&error]) {
    LOG("error %@", error)
  }
}
//上書き
- (void)updateData:(float)time
{
  LOG(@"time: %f",time)
  NSError* error = nil;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlayTime"];
  NSArray* fetchedArray = [_context executeFetchRequest:request error:&error];
  NSManagedObject *updateObj = [fetchedArray objectAtIndex:0];
  [updateObj setValue:[NSNumber numberWithFloat:time] forKey:@"time"];
  if (![_context save:&error]) {
    NSLog(@"Unresolved error %@", error);
    abort();
  }
}

//タイム取得
- (float)fetchTime
{
  NSError* error = nil;
  float res;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlayTime"];
  NSArray* fetchedArray = [_context executeFetchRequest:request error:&error];
  if (fetchedArray == nil) {
      LOG(@"Fetch Failure\n%@", [error localizedDescription])
      return res;
  }
  for (PlayTime *time in fetchedArray) {
    LOG(@"time: %@", time.time);
    res = [time.time floatValue];
  }
  return res;
}

//データリセット
- (void)resetData
{
  LOG()
  if (_dataObject) {
    [_context deleteObject:_dataObject];
    
    NSError *error;
    if (![_context save:&error]) {
      LOG("error %@", error)
    }
  }
}

//ゲームオーバーフラグ初期化
- (void)setGameOverFlag
{
  _gameOver = (TYGameOver *)[NSEntityDescription insertNewObjectForEntityForName:@"GameOver" inManagedObjectContext:_context];
  
  if (_gameOver == nil) {
    return;
  }
  [_gameOver setValue:[NSNumber numberWithBool:NO] forKey:@"gameOver"];
  
  NSError *error = nil;
  if (![_context save:&error]) {
    LOG("error %@", error)
  }
}

//ゲームオーバーフラグ取得
- (BOOL)fetchFlag
{
  NSError* error = nil;
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GameOver"];
  NSArray* fetchedArray = [_context executeFetchRequest:request error:&error];
  if (fetchedArray == nil) {
      LOG(@"Fetch Failure\n%@", [error localizedDescription])
  }
  NSManagedObject *obj = [fetchedArray objectAtIndex:0];
  NSNumber *num = [obj valueForKey:@"gameOver"];
  self.gameOverFlag = [num boolValue];
  return self.gameOverFlag;
}

//ゲームオーバーフラグ上書き
- (void)updateFlag
{
  NSError* error = nil;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GameOver"];
  NSArray* fetchedArray = [_context executeFetchRequest:request error:&error];
  NSManagedObject *updateObj = [fetchedArray objectAtIndex:0];
  NSNumber *num = [updateObj valueForKey:@"gameOver"];
  self.gameOverFlag = [num boolValue];
  if (self.gameOverFlag) {
    [updateObj setValue:[NSNumber numberWithBool:NO] forKey:@"gameOver"];
  } else {
    [updateObj setValue:[NSNumber numberWithBool:YES] forKey:@"gameOver"];
  }
  if (![_context save:&error]) {
    NSLog(@"Unresolved error %@", error);
    abort();
  }
}

@end
