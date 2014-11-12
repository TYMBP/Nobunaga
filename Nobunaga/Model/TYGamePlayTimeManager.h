//
//  TYGamePlayTimeManager.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/08/24.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TYGamePlayTimeManager : NSObject {
  NSURL *_storeURL;
}

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, assign) BOOL gameOverFlag;

+ (TYGamePlayTimeManager *)sharedmanager;
- (void)addData:(float)time;
- (float)fetchTime;
- (void)updateData:(float)time;
- (BOOL)fetchFlag;
- (void)updateFlag;
- (void)resetData;
@end
