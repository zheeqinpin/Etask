//
//  GlowResizingProtocol.h
//  GlowForum
//
//  Created by zwj on 15/8/25.
//  Copyright (c) 2015年 SJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GlowResizingProtocol;

static CGFloat GlowTopicTableViewCellAccessoryWidth = 33; // appx size measured

/**
 * Array that holds a single cell we use for "sizing" and measuring.
 * You use this to hold different cells you wish to calculate size
 * on. You don't want to create a cell each time to size with, that
 * would result in poor performance.
 *
 * Simply create a instance of your cell and add it to this array
 * to reuse.
 */
static NSMutableArray *cellArray;

/**
 * Block used to setup the cell prior to measuring the size.
 * You will configure the cellToSetup with all of your label/image
 * values as needed.
 */

typedef id (^setupCellBlock)(id<GlowResizingProtocol> cellToSetup);

@protocol GlowResizingProtocol <NSObject>

/**
 * Class method that you pass in the default cell size. You will configure
 * the cell's labels (and nil images in most cases) in the block.
 *
 * The default size passed should be used to init your "sizing" cell and
 * assist with setting max/min sizes.
 */
+ (CGSize)sizeForCellWithDefaultSize:(CGSize)defaultSize setupCellBlock:(setupCellBlock)block;

@end
