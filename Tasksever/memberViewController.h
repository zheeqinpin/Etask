//
//  memberViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/4/9.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ScaleToSize.h"
#import "user.h"
@interface memberViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) NSArray *MemberNameList;
@property (nonatomic) NSArray *managerNameList;
@property (nonatomic) user *user1;     //发布者ID
@property NSMutableArray *selectIndexs;

@end
