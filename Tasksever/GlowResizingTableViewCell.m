//
//  GlowResizingTableViewCell.m
//  GlowForum
//
//  Created by zwj on 15/8/25.
//  Copyright (c) 2015年 SJTU. All rights reserved.
//

#import "GlowResizingTableViewCell.h"

@implementation GlowResizingTableViewCell

+ (void)initialize {
    // Create array
    cellArray = [NSMutableArray array];
}

+ (CGSize)sizeForCellWithDefaultSize:(CGSize)defaultSize setupCellBlock:(setupCellBlock)block {
    
    // Check to see if we have a "sizing" cell to work with
    __block UITableViewCell *cell = nil;
    [cellArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[[self class] class]]) {
            cell = obj;
            *stop = YES;
        }
    }];
    
    if (!cell) {
        // Create and add to our static array using default size passed
        
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentsCellIdentifer"];
        cell.frame = CGRectMake(0, 0, defaultSize.width, defaultSize.height);
        [cellArray addObject:cell];
    }
    
    // Get our cell configured in block
    cell = block((id<GlowResizingProtocol>)cell);
    
    CGSize size = [((UITableViewCell *)cell).contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    size.width = MAX(defaultSize.width, size.width);
    
    // Return our size that was calculated
    return size;
}

@end
