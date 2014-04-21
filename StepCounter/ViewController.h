//
//  ViewController.h
//  StepCounter
//
//  Created by someone on 2014/04/21.
//  Copyright (c) 2014年 someone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotionManager.h"

@interface ViewController : UIViewController
<
UITableViewDataSource, UITableViewDelegate,
MotionManagerDelegate
>

@end
