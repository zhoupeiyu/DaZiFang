//
//  BaseImageButton.m
//  LXVolunteer
//
//  Created by 李涛 on 15/6/2.
//  Copyright (c) 2015年 lexue. All rights reserved.
//

#import "BaseImageButton.h"


static const CGFloat defaultMargin = 8;


@interface BaseImageButton()

@property (nonatomic,assign) CGFloat margin;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *highLightColor;
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *highLightImage;
@property (nonatomic,strong) UIColor *normalTextColor;
@property (nonatomic,strong) UIColor *highLightTextColor;
@property (nonatomic,strong) NSArray *marginArr;
@property (nonatomic,strong) UIColor *normalLayerColor;
@property (nonatomic,strong) UIColor *highLightLayerColor;

@property (nonatomic,assign) BaseImageButtonType type;
@property (nonatomic,assign) BOOL isHighLight;

@property (nonatomic,strong) UIView * view1;
@property (nonatomic,strong) UIView * view2;

@property (nonatomic,assign) CGFloat marginOne;
@property (nonatomic,assign) CGFloat marginTwo;
@property (nonatomic,assign) CGFloat marginThree;

@end


@implementation BaseImageButton

/**
 *  初始化
 *
 *  @param type 按钮生产类型 具体看BaseImageButtonType注释
 *  @param arr  一个NSNumber的数组，用来标示 图片和文本之间的间距 默认 从左到右，从上到下，默认取数组的前三个值
 *
 *  @return BaseImageButtonType
 */
- (instancetype)initWithType:(BaseImageButtonType)type AndMarginArr:(NSArray *)arr{
    self = [super init];
    if (self) {
        _marginArr = arr;
        _type = type;
        [self setRootSubView];
    }
    return self;
}

/**
 *  基础布局
 */
- (void)setRootSubView{
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor colorWithHex:0x131313];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.font = [UIFont kFont15];
    _contentLabel.text = _text;
    [self addSubview:_contentLabel];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = _image;
    [self addSubview:_imageView];
    
    
    /**
     *  根据传递的数组 来生成3个间距
     */
    if (_marginArr.count <= 0) {
        _marginArr = @[@0,[NSNumber numberWithFloat:defaultMargin],@0];
    }
    if (_marginArr.count == 1) {
        _marginArr = @[@0,_marginArr[0],@0];
    }
    
    if (_marginArr.count == 2) {
        _marginArr = @[_marginArr[0],_marginArr[1],@0];
    }
    
    _marginOne = [_marginArr[0] floatValue];
    _marginTwo = [_marginArr[1] floatValue];
    _marginThree = [_marginArr[2] floatValue];
    
    [self updateFrame];
}

/**
 *  设置按钮背景颜色 可以为nil
 *
 *  @param normalColor    正常颜色
 *  @param highLightColor 高亮颜色
 */
- (void)setNormolBackgroundColor:(UIColor *)normalColor AndHighLightColor:(UIColor *)highLightColor{
    _normalColor = normalColor;
    self.backgroundColor = _normalColor;
    _highLightColor = highLightColor;
}

/**
 *  设置按钮文本点击颜色 可以为nil
 *
 *  @param normalTextColor    正常文本颜色
 *  @param highLightTextColor 高亮文本颜色
 */
- (void)setNormolImage:(UIImage *)normalImage AndHighLightImage:(UIImage *)highLightImage{
    _normalImage = normalImage;
    [self setImage:normalImage];
    _highLightImage = highLightImage;
}

/**
 *  设置按钮边框颜色
 *
 *  @param normalLayColor      正常边框颜色
 *  @param highLightLayerColor 高亮边框颜色
 */
- (void)setNormolTextColor:(UIColor *)normalTextColor AndhighLightTextColor:(UIColor *)highLightTextColor{
    _normalTextColor = normalTextColor;
    _contentLabel.textColor = normalTextColor;
    _highLightTextColor = highLightTextColor;
}

/**
 *  初始化
 *
 *  @param type 按钮生产类型 具体看BaseImageButtonType注释
 *  @param arr  一个NSNumber的数组，用来标示 图片和文本之间的间距 默认 从左到右，从上到下，默认取数组的前三个值
 *
 *  @return BaseImageButtonType
 */
- (void)setNormolLayerColor:(UIColor *)normalLayColor AndhighLightLayerColor:(UIColor *)highLightLayerColor{
    _normalLayerColor = normalLayColor;
    self.layer.borderColor = _normalLayerColor.CGColor;
    _highLightLayerColor = highLightLayerColor;
}

/**
 *  设置文本
 *
 *  @param text 文本
 */
- (void)setText:(NSString *)text{
    _contentLabel.text = text;
    [_contentLabel sizeToFit];
    _text = text;
}

/**
 *  设置展示图片
 *
 *  @param image 图片
 */
- (void)setImage:(UIImage *)image{
    _imageView.image = image;
    _image = image;
}

- (void)setIsNeedRotation:(BOOL)isNeedRotation{
    _isNeedRotation = isNeedRotation;
    if(_isNeedRotation){
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.transform = CGAffineTransformMakeRotation(M_PI - 0.01);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark Touch事件监听

/**
 *  开始Touch 设置高亮
 *
 *  @param touch a
 *  @param event b
 *
 *  @return 是否接受Touch事件
 */
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self setHighLight];
    return YES;
}

/**
 *  持续Touch 设置高亮
 *
 *  @param touch touch
 *  @param event event
 *
 *  @return 是否接受持续点击事件
 */
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self setHighLight];
    return YES;
}

/**
 *  取消Touch 取消高亮，恢复正常
 *
 *  @param event
 */
- (void)cancelTrackingWithEvent:(UIEvent *)event{
    [self setNormal];
}

/**
 *  结束Touch 取消高亮，恢复正常
 *
 *  @param touch touch
 *  @param event event
 */
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self setNormal];
}

#pragma mark 事件

/**
 *   设置高亮 所有的高亮操作应该在本方法中完成
 */
- (void)setHighLight{
    
    if (_isHighLight) {
        return;
    }
    _isHighLight = YES;
    if (_highLightColor) {
        self.backgroundColor = _highLightColor;
    }
    if (_highLightImage) {
        _imageView.image = _highLightImage;
    }
    if (_highLightTextColor) {
        _contentLabel.textColor = _highLightTextColor;
    }
    if (_highLightLayerColor) {
        self.layer.borderColor = _highLightLayerColor.CGColor;
    }
}

/**
 *  设置正常 所有的恢复正常操作应该在本方法中完成
 */
- (void)setNormal{
    
    if (!_isHighLight) {
        return;
    }
    _isHighLight = NO;
    if (_normalColor) {
        self.backgroundColor = _normalColor;
    }
    if (_normalImage) {
        _imageView.image = _normalImage;
    }
    if (_normalTextColor) {
        _contentLabel.textColor = _normalTextColor;
    }
    
    if (_normalLayerColor) {
        self.layer.borderColor = _normalLayerColor.CGColor;
    }
}
/**
 *  设置图片居左，文本居右约束，影响撑开父布局
 */
- (void)setSideLeft{
    
    WS(ws);
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.left.mas_equalTo(ws.mas_left).offset(_marginOne);
        make.width.priorityLow();
        make.width.mas_lessThanOrEqualTo(ws.mas_width);
        make.right.mas_equalTo(_contentLabel.mas_left).offset(-_marginTwo);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.right.mas_equalTo(ws.mas_right).offset(-_marginThree);
        
        
    }];
    
    [ws mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(_imageView.mas_height);
        make.height.mas_greaterThanOrEqualTo(_contentLabel.mas_height);
    }];
}

/**
 *  设置图片居右，文本居左约束，影响撑开父布局
 */
- (void)setSideRight{
    
    WS(ws);
    
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.right.mas_equalTo(ws.mas_right).offset(-_marginThree);
        make.width.priorityLow();
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.left.mas_equalTo(ws.mas_left).offset(_marginOne);
        make.right.mas_equalTo(_imageView.mas_left).offset(-_marginTwo);
        
    }];
    
    [ws mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(_imageView.mas_height);
        make.height.mas_greaterThanOrEqualTo(_contentLabel.mas_height);
    }];
}
/**
 *  设置图片居左，文本居右约束，影响父布局
 */
- (void)setLeft{

    WS(ws);
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.left.mas_equalTo(ws.mas_left).offset(_marginOne);
        make.right.mas_equalTo(_contentLabel.mas_left).offset(-_marginTwo);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.right.mas_equalTo(ws.mas_right).offset(-_marginThree);
        make.width.priorityLow();
        make.width.mas_lessThanOrEqualTo(ws.mas_width);
        
    }];
    
    [ws mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(_imageView.mas_height);
        make.height.mas_greaterThanOrEqualTo(_contentLabel.mas_height);
    }];
}

/**
 *  设置图片居右，文本居左约束，影响父布局
 */
- (void)setRight{
    
    WS(ws);
    
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.right.mas_equalTo(ws.mas_right).offset(-_marginThree);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.left.mas_equalTo(ws.mas_left).offset(_marginOne);
        make.right.mas_equalTo(_imageView.mas_left).offset(-_marginTwo);
        make.width.priorityLow();
    }];
    
    [ws mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(_imageView.mas_height);
        make.height.mas_greaterThanOrEqualTo(_contentLabel.mas_height);
    }];
}

/**
 *  设置图片居上，文本居下约束，影响父布局
 */
- (void)setTop{
    
    WS(ws);
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.mas_centerX);
        make.top.mas_equalTo(ws.mas_top).offset(_marginOne);
        make.bottom.mas_equalTo(_contentLabel.mas_top).offset(-_marginTwo);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.mas_centerX);
        make.bottom.mas_equalTo(ws.mas_bottom).offset(-_marginThree);
    }];
    
    [ws mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(_imageView.mas_width);
        make.width.mas_greaterThanOrEqualTo(_contentLabel.mas_width);
    }];

}

/**
 *  设置图片居下，文本居上约束，影响父布局
 */
- (void)setBottom{
    
    WS(ws);
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.mas_centerX);
        make.top.mas_equalTo(ws.mas_top).offset(_marginOne);
        make.bottom.mas_equalTo(_imageView.mas_top).offset(-_marginTwo);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.mas_centerX);
        make.bottom.mas_equalTo(ws.mas_bottom).offset(-_marginThree);
    }];
    
    [ws mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(_imageView.mas_width);
        make.width.mas_greaterThanOrEqualTo(_contentLabel.mas_width);
    }];
}


/**
 *  设置图片居左，文本居右约束，整体居中
 */
- (void)setCenterLeft{
    
    _view1 = [[UIView alloc] init];
    _view1.userInteractionEnabled = NO;

    [self addSubview:_view1];

    _view2 = [[UIView alloc] init];
    _view2.userInteractionEnabled = NO;
    [self addSubview:_view2];
    
    WS(ws);
    
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left);
        make.right.mas_equalTo(_imageView.mas_left);
        make.top.mas_equalTo(ws.mas_top);
        make.bottom.mas_equalTo(ws.mas_bottom);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_contentLabel.mas_left).offset(-_marginTwo);
        make.centerY.mas_equalTo(ws.mas_centerY);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_view2.mas_left);
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.width.priorityLow();
    }];
    
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.mas_right);
        make.top.mas_equalTo(ws.mas_top);
        make.bottom.mas_equalTo(ws.mas_bottom);
        make.width.mas_equalTo(_view1.mas_width);
    }];
    
    [ws mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(_imageView.mas_height);
        make.height.mas_greaterThanOrEqualTo(_contentLabel.mas_height);
    }];
}


/**
 *  设置图片居右，文本居左约束，整体居中
 */
- (void)setCenterRight{

    _view1 = [[UIView alloc] init];
    _view1.userInteractionEnabled = NO;
    [self addSubview:_view1];
    
    _view2 = [[UIView alloc] init];
    _view2.userInteractionEnabled = NO;
    [self addSubview:_view2];
    
    WS(ws);
    
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left);
        make.right.mas_equalTo(_contentLabel.mas_left);
        make.top.mas_equalTo(ws.mas_top);
        make.bottom.mas_equalTo(ws.mas_bottom);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_imageView.mas_left).offset(-_marginTwo);
        make.centerY.mas_equalTo(ws.mas_centerY);
        make.width.priorityLow();
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_view2.mas_left);
        make.centerY.mas_equalTo(ws.mas_centerY);
    }];
    
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.mas_right);
        make.top.mas_equalTo(ws.mas_top);
        make.bottom.mas_equalTo(ws.mas_bottom);
        make.width.mas_equalTo(_view1.mas_width);
    }];
    
    [ws mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(_imageView.mas_height);
        make.height.mas_greaterThanOrEqualTo(_contentLabel.mas_height);
    }];

}


/**
 *  设置图片居上，文本居下约束，整体居中
 */
- (void)setCenterTop{
    
    _view1 = [[UIView alloc] init];
    _view1.userInteractionEnabled = NO;
    [self addSubview:_view1];
    
    _view2 = [[UIView alloc] init];
    _view2.userInteractionEnabled = NO;
    [self addSubview:_view2];
    
    WS(ws);
    
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left);
        make.right.mas_equalTo(ws.mas_left);
        make.top.mas_equalTo(ws.mas_top);
        make.bottom.mas_equalTo(_imageView.mas_top);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_contentLabel.mas_top).offset(-_marginTwo);
        make.centerX.mas_equalTo(ws.mas_centerX);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_view2.mas_top);
        make.centerX.mas_equalTo(ws.mas_centerX);
    }];
    
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.mas_right);
        make.left.mas_equalTo(ws.mas_left);
        make.bottom.mas_equalTo(ws.mas_bottom);
        make.height.mas_equalTo(_view1.mas_height);
    }];
    
    [ws mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(_imageView.mas_width);
        make.width.mas_greaterThanOrEqualTo(_contentLabel.mas_width);
    }];
    
}

/**
 *  设置图片居下，文本居上约束，整体居中
 */
- (void)setCenterBottom{
    _view1 = [[UIView alloc] init];
    _view1.userInteractionEnabled = NO;
    [self addSubview:_view1];
    
    _view2 = [[UIView alloc] init];
    _view2.userInteractionEnabled = NO;
    [self addSubview:_view2];
    
    WS(ws);
    
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left);
        make.right.mas_equalTo(ws.mas_left);
        make.top.mas_equalTo(ws.mas_top);
        make.bottom.mas_equalTo(_contentLabel.mas_top);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_imageView.mas_top).offset(-_marginTwo);
        make.centerX.mas_equalTo(ws.mas_centerX);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_view2.mas_top);
        make.centerX.mas_equalTo(ws.mas_centerX);
    }];
    
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.mas_right);
        make.left.mas_equalTo(ws.mas_left);
        make.bottom.mas_equalTo(ws.mas_bottom);
        make.height.mas_equalTo(_view1.mas_height);
    }];
    
    [ws mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(_imageView.mas_width);
        make.width.mas_greaterThanOrEqualTo(_contentLabel.mas_width);
    }];
}

/**
 *  根据类型来更新约束
 */
- (void)updateFrame{
    switch (_type) {
        case BaseImageButtonTypeLeft:
        {
            [self setLeft];
            break;
        }
        case BaseImageButtonTypeRight:
        {
            [self setRight];
            break;
        }
        case BaseImageButtonTypeTop:
        {
            [self setTop];
            break;
        }
        case BaseImageButtonTypeBottom:
        {
            [self setBottom];
            break;
        }
        case BaseImageButtonTypeCenterLeft:
        {
            [self setCenterLeft];
            break;
        }
            
        case BaseImageButtonTypeCenterRight:
        {
            [self setCenterRight];
            break;
        }
        case BaseImageButtonTypeCenterTop:
        {
            [self setCenterTop];
            break;
        }
        case BaseImageButtonTypeCenterBottom:
        {
            [self setCenterBottom];
            break;
        }
        case BaseImageButtonTypeSideLeft:
        {
            [self setSideLeft];
            break;
        }
        case  BaseImageButtonTypeSideRight:
        {
            [self setSideRight];
            break;
        }
        default:
            break;
    }
}

/**
 *  设置不可用
 *
 *  @param enabled 颜色透明度变化
 */
- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        self.alpha = 1.0;
    }else{
        self.alpha = 0.6;
    }
    
}

@end
