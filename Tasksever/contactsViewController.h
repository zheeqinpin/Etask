//
//  contactsViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/3/16.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"

@interface contactsViewController : UIViewController<UITableViewDataSource,UITableViewDataSource>
@property (nonatomic) user *user1;
@property (nonatomic ,retain) NSMutableArray *projectTitle;
@property (nonatomic ,retain) NSMutableArray *projectId;
@property (nonatomic ,retain) NSMutableArray *projectImage;
@property (nonatomic ,retain) NSMutableArray *projectDescription;
@property (nonatomic ,retain) NSMutableArray *userPower;
@property (nonatomic ,retain) NSMutableArray *publiseNameList;
@end
