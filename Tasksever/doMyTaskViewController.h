//
//  doMyTaskViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/5/1.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
@interface doMyTaskViewController : UIViewController<UITableViewDataSource,UITabBarDelegate,UITabBarDelegate,UITableViewDelegate>
@property (nonatomic) user *user1;
@property (nonatomic ) NSString *projectId;
@property (nonatomic ,retain) NSMutableArray *taskTitle;
@property (nonatomic ,retain) NSMutableArray *taskId;
@property (nonatomic) NSString *titleForSections;
@end
