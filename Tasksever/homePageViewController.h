//
//  homePageViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/3/16.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"

@interface homePageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) user *user1;
@property (nonatomic ,retain) NSMutableArray *taskTitleList;
@property (nonatomic, retain) NSMutableArray *taskImageList;
@property (nonatomic, retain) NSMutableArray *taskGroupList;
@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger section;//选中的是第几行第几块
@end
