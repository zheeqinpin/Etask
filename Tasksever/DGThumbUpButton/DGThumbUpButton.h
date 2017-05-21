//
//  DGThumbUpButton.h
//  DGThumbUpButton
//
//  Created by Desgard_Duan on 16/6/9.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
typedef NS_ENUM(NSUInteger, DGThumbUpButtonType) {
    DGThumbUpExplosionType = 0
};

@interface DGThumbUpButton : UIButton
@property (nonatomic) NSString *anwserId;
@property (nonatomic) user *user1;
- (instancetype) initWithFrame: (CGRect)frame isPress: (BOOL)press;
- (void) clickButtonPress;

@end
