//
//  PlayTime.h
//  Nobunaga
//
//  Created by Tomohiko on 2014/08/24.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlayTime : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * time;

@end
