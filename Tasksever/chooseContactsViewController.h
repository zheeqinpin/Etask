//
//  chooseContactsViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/4/25.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ScaleToSize.h"
#import "user.h"

@interface chooseContactsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) user *user1;
@property NSMutableArray *selectIndexs;
@property (nonatomic, retain) NSMutableArray *friendNameList;
@property (nonatomic, retain) NSArray *idList;
@property (nonatomic) NSInteger judgeChooseManagerOrMember;
@end
