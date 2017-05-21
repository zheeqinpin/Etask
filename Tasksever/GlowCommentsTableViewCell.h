//
//  GlowCommentsTableViewCell.h
//  GlowForum
//
//  Created by zwj on 15/8/25.
//  Copyright (c) 2015年 SJTU. All rights reserved.
//

#import "GlowResizingTableViewCell.h"
#import "GlowResizingProtocol.h"
#import "NSString+TimeInterval.h"
#import "UIImage+ScaleToSize.h"
#import "user.h"

#define DEFAULT_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 120}

@interface GlowCommentsTableViewCell : GlowResizingTableViewCell
@property (nonatomic) NSString *anwserId;
@property (nonatomic) user *user1;
- (void)setupCellWithData:(NSDictionary *)data;

@end
