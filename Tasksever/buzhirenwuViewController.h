//
//  buzhirenwuViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/4/30.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
@interface buzhirenwuViewController : UIViewController<UITextViewDelegate>
@property (nonatomic ) NSString *projectId; //项目ID用于获取数据
@property (nonatomic,retain ) NSMutableArray *memberNameList;
@property (nonatomic,retain ) NSMutableArray *managerNameList;
@property (nonatomic) user *user1;
@end
