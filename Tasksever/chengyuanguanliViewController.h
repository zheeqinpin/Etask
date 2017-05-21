//
//  chengyuanguanliViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/4/30.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
#import "UIImage+ScaleToSize.h"
@interface chengyuanguanliViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray *memberNameList;
@property (nonatomic, retain) NSMutableArray *managerNameList;
@property (nonatomic) user *user1;     //发布者ID
@property (nonatomic ) NSString *userPower; //用户权限
@property (nonatomic,retain ) NSMutableArray *joinerNameList; //用户权限
@property (nonatomic) NSInteger judgeMemberOrJoin;
@property (nonatomic ) NSString *publishName;
@property (nonatomic ) NSString *projectId; 
@end
