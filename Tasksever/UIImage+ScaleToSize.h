//
//  UIImage+ScaleToSize.h
//  GlowForum
//
//  Created by zwj on 15/8/26.
//  Copyright (c) 2015年 SJTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScaleToSize)

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

@end
