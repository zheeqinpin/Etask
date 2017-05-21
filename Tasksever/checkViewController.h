//
//  checkViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/3/21.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
@interface checkViewController : UIViewController<UITableViewDataSource,UITabBarDelegate,UITabBarDelegate,UITableViewDataSource>
@property (nonatomic) user *user1;
@property (nonatomic ) NSString *projectId; //项目名
@property (nonatomic ,retain) NSMutableArray *taskTitleList;
@property (nonatomic ,retain) NSMutableArray *taskIdList;
@property (nonatomic ,retain) NSMutableArray *taskImageList;
@property (nonatomic ,retain) NSMutableArray *questioonTitleList;
@property (nonatomic ,retain) NSMutableArray *questionIdList;
@property (nonatomic ,retain) NSMutableArray *askNameList;
@property (nonatomic ,retain) NSMutableArray *askIdList;
@property (nonatomic ) NSString *taskid;
@property (nonatomic ) NSString *taskDesc;
@property (nonatomic ) NSString *creatTime;
@property (nonatomic ) NSString *deadLine;
@property (nonatomic ) NSString *taskName;

@end
