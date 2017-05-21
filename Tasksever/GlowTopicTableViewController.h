//
//  GlowTopicTableViewController.h
//  GlowForum
//
//  Created by zwj on 15/8/25.
//  Copyright (c) 2015年 SJTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlowTopicTableViewCell.h"
#import "GlowCommentsTableViewCell.h"
#import "GlowResizingProtocol.h"
#import "AppDelegate.h"
#import "user.h"
@interface GlowTopicTableViewController : UITableViewController<UITableViewDataSource,UITabBarDelegate,UITabBarDelegate,UITableViewDelegate>
@property (nonatomic) NSInteger *rowOfData;//用来判断数据位置
@property (strong, nonatomic) NSMutableArray *jsonArray;
@property (strong, nonatomic) NSDictionary *jsonDict0;   //问题相关数据
@property (strong, nonatomic) NSDictionary *jsonDict1;   //问题相关数据
@property (strong, nonatomic) NSDictionary *jsonDict2;  //回答相关数据
@property (strong, nonatomic) NSArray *sortedCommentsArray;  //回复者相关数据
@property (nonatomic ) NSString *askName;
@property (nonatomic) user *user1;
@property (nonatomic ) NSString *askId;
@end
