//
//  ViewController.m
//  StepCounter
//
//  Created by someone on 2014/04/21.
//  Copyright (c) 2014年 someone. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currentStepsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self configureMotionManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureMotionManager
{
    MotionManager *motionManager = [MotionManager sharedManager];
    if([motionManager isStepCountingAvailable])
    {
        motionManager.delegate = self;
        [motionManager startQueryStepCount];
        [motionManager startStepContinuingUpdates];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"M7コプロセッサ搭載端末でお試しください"
                                                           delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[MotionManager sharedManager] dateCount];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    NSDate *date = [[MotionManager sharedManager] getDateForindex:indexPath.row];
    NSNumber *steps = [[MotionManager sharedManager] getStepsForIndex:indexPath.row];
    
    NSString *strStep = [NSString stringWithFormat:@"%@", steps];
    NSString *strDate = [formatter stringFromDate:date];
    
    cell.textLabel.text = strDate;
    cell.detailTextLabel.text = strStep;
    
    return cell;
}

-(void)motionManagerQueryFinishedd
{
    [self.tableView reloadData];
}

-(void)motionManagerCurrentStepsUpdated:(NSInteger)numberOfSteps
{
    self.currentStepsLabel.text = [NSString stringWithFormat:@"%ld", numberOfSteps];
}

@end
