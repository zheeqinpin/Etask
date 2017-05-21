//
//  handinViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/3/20.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "finishedOrNot.h"
#import "user.h"
@interface handinViewController : UIViewController<UITextViewDelegate>
@property (nonatomic) user *user1;
@property (nonatomic) NSString *taskId;
@property (nonatomic) NSString *taskDescription;
@property (nonatomic) NSString *creatTime;
@property (nonatomic) NSString *deadline;
@property (nonatomic) NSInteger judgeIfManagerEnterThisPage;
@property (nonatomic, retain) NSMutableArray *finishNameLis;
@property   (nonatomic, retain) NSMutableArray *finishIdList;
@property (nonatomic, retain) NSMutableArray *unfinishNameLis;
@property   (nonatomic, retain) NSMutableArray *unfinishIdList;
@property (nonatomic) NSString *taskName;
@end
