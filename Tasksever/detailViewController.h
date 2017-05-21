//
//  detailViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/3/19.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"

@interface detailViewController : UIViewController<UITextViewDelegate>
@property (nonatomic, retain) NSMutableArray *friendNameList;
@property (nonatomic) NSInteger a;  //用于判断是创建问卷还是任务
@property (nonatomic) user *user1;
@end
