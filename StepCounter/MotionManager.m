//
//  MotionManager.m
//  StepCounter
//
//  Created by someone on 2014/04/21.
//  Copyright (c) 2014年 someone. All rights reserved.
//

#import "MotionManager.h"

#define kMaxDays 7

@interface MotionManager()

@property(readwrite) NSInteger todaySteps;
@property(nonatomic, strong) CMStepCounter *stepCounter;
@property(nonatomic, strong) NSMutableArray *stepsArray;

@end

@implementation MotionManager

+(instancetype)sharedManager
{
    static id manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(id)init
{
    self = [super init];
    if(self){
        _stepCounter = [[CMStepCounter alloc] init];
    }
    return self;
}

-(BOOL)isStepCountingAvailable
{
    return [CMStepCounter isStepCountingAvailable];
}

-(void)startQueryStepCount
{
    self.stepsArray = [NSMutableArray array];
    
    if([self isStepCountingAvailable])
    {
        NSDate *todayDate = [self startOfDay:[NSDate date]];
        
        NSTimeInterval oneDayInterval = 24.0f * 60.0f * 60.0f;
        
        for(NSInteger i=0; i<kMaxDays; i++)
        {
            NSTimeInterval interval = oneDayInterval * i;
            
            NSDate *fromDate = [todayDate dateByAddingTimeInterval:-interval];
            NSDate *toDate = [fromDate dateByAddingTimeInterval:oneDayInterval];
            
            [self.stepCounter queryStepCountStartingFrom:fromDate
                                                      to:toDate
                                                 toQueue:[NSOperationQueue mainQueue]
                                             withHandler:^(NSInteger numberOfSteps, NSError *error)
             {
                 if(!error)
                 {
                     if([fromDate isEqualToDate:todayDate])
                     {
                         self.todaySteps = numberOfSteps;
                         [self.delegate motionManagerCurrentStepsUpdated:self.todaySteps];
                     }
                     else {
                         NSDictionary *dict = @{kDictionaryDateKey: fromDate, kDictionaryStepsKey: @(numberOfSteps)};
                         [self.stepsArray addObject:dict];
                     }
                     
                     if(self.stepsArray.count == kMaxDays-1)
                     {
                         [self.stepsArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
                          {
                             NSDictionary *dict1 = obj1;
                             NSDictionary *dict2 = obj2;
                             
                             NSDate *date1 = dict1[kDictionaryDateKey];
                             NSDate *date2 = dict2[kDictionaryDateKey];
                             
                             return [date2 compare:date1];
                          }];
                         [self.delegate motionManagerQueryFinishedd];
                     }
                 }
             }];
        }
    }
}

-(NSDate *)startOfDay:(NSDate *)date
{
    NSDateFormatter *dateFormatteer = [[NSDateFormatter alloc] init];
    [dateFormatteer setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatteer setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *strToday = [dateFormatteer stringFromDate:date];
    NSDate *twelveDate = [dateFormatteer dateFromString:strToday];
    
    return twelveDate;
}

-(void)startStepContinuingUpdates
{
    if([self isStepCountingAvailable])
    {
        [self.stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue]
                                                 updateOn:1
                                              withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error)
         {
             [self.delegate motionManagerCurrentStepsUpdated:self.todaySteps + numberOfSteps];
         }];
    }
}

-(NSUInteger)dateCount
{
    return self.stepsArray.count;
}

-(NSDate *)getDateForindex:(NSUInteger)index
{
    NSDictionary *dict = self.stepsArray[index];
    return dict[kDictionaryDateKey];
}

-(NSNumber *)getStepsForIndex:(NSUInteger)index
{
    NSDictionary *dict = self.stepsArray[index];
    return dict[kDictionaryStepsKey];
}

@end
