//
//  groupInformationViewController.h
//  Tasksever
//
//  Created by qingping zheng on 17/5/1.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface groupInformationViewController : UIViewController
@property (nonatomic ) NSString *projectId; //项目ID用于获取数据
@property (nonatomic ) NSString *projectTitle; //项目名
@property (nonatomic ) NSString *projectDescription;
@property (nonatomic ) NSString *projectImageString;
@property (nonatomic ) NSString *publishName;
@end
