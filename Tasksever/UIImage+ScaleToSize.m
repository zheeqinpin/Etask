//
//  UIImage+ScaleToSize.m
//  GlowForum
//
//  Created by zwj on 15/8/26.
//  Copyright (c) 2015年 SJTU. All rights reserved.
//

#import "UIImage+ScaleToSize.h"

@implementation UIImage (ScaleToSize)

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

@end
