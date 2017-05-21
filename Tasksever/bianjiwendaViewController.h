//
//  bianjiwendaViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/4/30.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
@interface bianjiwendaViewController : UIViewController<UITextViewDelegate>
@property (nonatomic) user *user1;
@property (nonatomic ) NSString *projectId; 
@end
