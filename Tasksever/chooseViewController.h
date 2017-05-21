//
//  chooseViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/3/25.
//  Copyright © 2017年 zln. All rights reserved.
//
/*任务分配选贼成员
 */
#import <UIKit/UIKit.h>
#import "UIImage+ScaleToSize.h"
#import "user.h"

@interface chooseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property NSMutableArray *selectmember;
@property (nonatomic) NSArray *chooseMemberNameList;
@property (nonatomic) NSArray *chooseMemberIdList;
@end
