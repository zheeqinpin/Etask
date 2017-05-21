//
//  messageViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/3/16.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ScaleToSize.h"
#import "user.h"

@interface messageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) user *user1;
@property (nonatomic, retain) NSMutableArray *friendNameList;
@property (nonatomic, retain) NSMutableArray *friendInviteNameList;
@property (nonatomic) NSInteger judgeFriendType;
//@property (nonatomic, retain) NSArray *idList;
@end
