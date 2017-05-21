//
//  wanchegnrenViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/3/26.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
#import "UIImage+ScaleToSize.h"
@interface wanchegnrenViewController : UIViewController<UITableViewDataSource,UITabBarDelegate>
@property (nonatomic) user *user1;
@property (nonatomic, retain) NSMutableArray *finishNameLis;
@property   (nonatomic, retain) NSMutableArray *finishIdList;
@property (nonatomic, retain) NSMutableArray *unfinishNameLis;
@property   (nonatomic, retain) NSMutableArray *unfinishIdList;
@property (nonatomic, retain) NSString *taskId;
@property (nonatomic) NSInteger judgeIfFinishMemberList;

@end
