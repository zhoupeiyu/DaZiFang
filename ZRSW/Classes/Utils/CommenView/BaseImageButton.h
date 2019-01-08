//
//  BaseImageButton.h
//  LXVolunteer
//
//  Created by 李涛 on 15/6/2.
//  Copyright (c) 2015年 lexue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BaseImageButtonType){
    
    /**
     *  按钮图片居下 文案居上 可以影响父布局的大小
     */
    BaseImageButtonTypeLeft = 0,
    
    /**
     *  按钮图片居右 文案居左 可以影响父布局的大小
     */
    BaseImageButtonTypeRight,
    
    /**
     *  按钮图片居上 文案居下 可以影响父布局的大小
     */
    BaseImageButtonTypeTop,
    
    /**
     *  按钮图片居下 文案居上 可以影响父布局的大小
     */
    BaseImageButtonTypeBottom,
    
    /**
     *  按钮图片居左 文案居右 水平垂直整体居中
     */
    BaseImageButtonTypeCenterLeft,
    
    /**
     *  按钮图片居右 文案居左 水平垂直整体居中
     */
    BaseImageButtonTypeCenterRight,
    
    /**
     *  按钮图片居上 文案居下 水平垂直整体居中
     */
    BaseImageButtonTypeCenterTop,
    
    /**
     *  按钮图片居下 文案居上 水平垂直整体居中
     */
    BaseImageButtonTypeCenterBottom,
    
    /**
     *  按钮图片居左 文案居右 撑开view
     */
    BaseImageButtonTypeSideLeft,
    /**
     *  按钮图片居you 文案居zuo 撑开view
     */
    BaseImageButtonTypeSideRight,

};


@interface BaseImageButton : UIControl

/**
 *  文本
 */
@property (nonatomic,strong) NSString * text;

/**
 *  图片
 */
@property (nonatomic,strong) UIImage * image;

/**
 *  展示文本的Label 可以用来自定义一些属性
 */
@property (nonatomic,strong) UILabel * contentLabel;

/**
 *  展示图片的ImageView 用来自定义部分属性
 */
@property (nonatomic,strong) UIImageView * imageView;

/**
 *  是否需要旋转
 */
@property (nonatomic,assign) BOOL isNeedRotation;

/**
 *  是否选中
 */
@property (nonatomic,assign) BOOL isSelected;

/**
 *  设置按钮背景颜色 可以为nil
 *
 *  @param normalColor    正常颜色
 *  @param highLightColor 高亮颜色
 */
- (void)setNormolBackgroundColor:(UIColor *)normalColor AndHighLightColor:(UIColor *)highLightColor;

/**
 *  设置按钮图片 可以为nil
 *
 *  @param normalImage    正常图片
 *  @param highLightImage 高亮图片
 */
- (void)setNormolImage:(UIImage *)normalImage AndHighLightImage:(UIImage *)highLightImage;

/**
 *  设置按钮文本点击颜色 可以为nil
 *
 *  @param normalTextColor    正常文本颜色
 *  @param highLightTextColor 高亮文本颜色
 */
- (void)setNormolTextColor:(UIColor *)normalTextColor AndhighLightTextColor:(UIColor *)highLightTextColor;

/**
 *  设置按钮边框颜色
 *
 *  @param normalLayColor      正常边框颜色
 *  @param highLightLayerColor 高亮边框颜色
 */
- (void)setNormolLayerColor:(UIColor *)normalLayColor AndhighLightLayerColor:(UIColor *)highLightLayerColor;


/**
 *  初始化
 *
 *  @param type 按钮生产类型 具体看BaseImageButtonType注释
 *  @param arr  一个NSNumber的数组，用来标示 图片和文本之间的间距 默认 从左到右，从上到下，默认取数组的前三个值
 *
 *  @return BaseImageButtonType
 */
- (instancetype)initWithType:(BaseImageButtonType)type AndMarginArr:(NSArray *)arr;

@end
