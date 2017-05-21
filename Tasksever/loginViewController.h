//
//  loginViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/3/17.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
@interface loginViewController : UIViewController
-(IBAction)loginButtonAction:(id)sender;
-(IBAction)signinButtonAction:(id)sender;
-(IBAction)findpsd:(id)sender;
@property (nonatomic) user *user1;
@end
