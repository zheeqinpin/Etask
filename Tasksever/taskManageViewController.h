//
//  taskManageViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/3/16.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "user.h"

@interface taskManageViewController : UIViewController<UITabBarDelegate,UITableViewDataSource>
@property (nonatomic) user *user1;
@property (nonatomic, retain) NSMutableArray *titleList;
@property   (nonatomic, retain) NSMutableArray *idList;
//@property (nonatomic, retain) NSMutableArray *finishTitleList;
//@property (nonatomic, retain) NSMutableArray *finishIdList;
@property (nonatomic ,retain) NSMutableArray *projectTitle;
@property (nonatomic ,retain) NSMutableArray *projectId;
@property (nonatomic ,retain) NSMutableArray *projectImage;
@property (nonatomic ,retain) NSMutableArray *publiseNameList;
@property (nonatomic ,retain) NSMutableArray *projectDescription;
@property (nonatomic ,retain) NSMutableArray *questionName;
@property (nonatomic ,retain) NSMutableArray *questionId;
@end
