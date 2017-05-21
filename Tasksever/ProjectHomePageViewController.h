//
//  ProjectHomePageViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/4/30.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
@interface ProjectHomePageViewController : UIViewController
@property (nonatomic ) NSString *projectId; //项目ID用于获取数据
@property (nonatomic ) NSString *projectTitle; //项目名
@property (nonatomic ) NSString *projectDescription;
@property (nonatomic ) NSString *publishName;
@property (nonatomic ) NSString *projectImageString;
@property (nonatomic ) NSString *userPower; //用户权限
@property (nonatomic,retain ) NSMutableArray *memberNameList;
@property (nonatomic,retain ) NSMutableArray *memberIdList;
@property (nonatomic,retain ) NSMutableArray *managerNameList;
@property (nonatomic,retain ) NSMutableArray *joinerNameList;
//@property (nonatomic,retain ) NSMutableArray *joinGroupIdList;
@property (nonatomic) NSInteger judgeWhoEnterThisPage;
@property (nonatomic) user *user1;
@end
