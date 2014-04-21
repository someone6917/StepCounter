//
//  MotionManager.h
//  StepCounter
//
//  Created by someone on 2014/04/21.
//  Copyright (c) 2014年 someone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MotionManagerDelegate <NSObject>

-(void)motionManagerQueryFinishedd;
-(void)motionManagerCurrentStepsUpdated:(NSInteger)numberOfSteps;

@end

@interface MotionManager : NSObject

@property(nonatomic, strong) id<MotionManagerDelegate> delegate;

+(instancetype)sharedManager;

-(BOOL)isStepCountingAvailable;
-(void)startQueryStepCount;
-(void)startStepContinuingUpdates;

-(NSUInteger)dateCount;
-(NSNumber *)getStepsForIndex:(NSUInteger)index;
-(NSDate *)getDateForindex:(NSUInteger)index;

@end
