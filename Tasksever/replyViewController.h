//
//  replyViewController.h
//  GlowForum
//
//  Created by qingping zheng on 17/4/9.
//  Copyright © 2017年 SJTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
@interface replyViewController : UIViewController<UITextViewDelegate>
@property (nonatomic) user *user1;
@property (nonatomic ) NSString *askId;
@end
