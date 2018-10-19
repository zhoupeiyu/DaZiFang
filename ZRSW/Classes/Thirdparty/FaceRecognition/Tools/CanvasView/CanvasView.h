//
//  CanvasView.h
//  ZRSW
//
//  Created by King on 2018/10/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface CanvasView : UIView
#define POINTS_KEY @"POINTS_KEY"
#define RECT_KEY   @"RECT_KEY"
#define RECT_ORI   @"RECT_ORI"
@property (nonatomic , strong) NSArray *arrPersons ;
@property (nonatomic , strong) NSArray *arrFixed;

@end
