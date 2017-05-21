//
//  fenpeiViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/3/24.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"

@interface fenpeiViewController : UIViewController
@property (nonatomic) user *user1;
@property (nonatomic ) NSString *projectId; //项目ID用于获取数据
@end
