//
//  upLoadFileViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/5/1.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
@interface upLoadFileViewController : UIViewController<UITextViewDelegate>
@property (nonatomic) user *user1;
@property (nonatomic) NSString *taskId;
@property (nonatomic) NSString *taskName;
@end
