//
//  UIView+Extension.h
//
//

#import <UIKit/UIKit.h>

typedef void (^TapActionBlock)(UITapGestureRecognizer *gestureRecoginzer);
typedef void (^LongPressActionBlock)(UILongPressGestureRecognizer *gestureRecoginzer);

typedef enum : NSUInteger {
    GradientLayerDirectionDefault, // 默认水平方向
    GradientLayerDirectionHorizontal, // 水平方向
    GradientLayerDirectionVertical, // 垂直方向
} GradientLayerDirection;

@interface UIView (Extension)

/** UIView 的坐标X点 */
@property (nonatomic, assign) CGFloat x;
/** UIView 的坐标Y点 */
@property (nonatomic, assign) CGFloat y;

/** UIView 的中心点X值 */
@property (nonatomic, assign) CGFloat centerX;
/** UIView 的中心点Y值 */
@property (nonatomic, assign) CGFloat centerY;

/** UIView的最大X值 */
@property (assign, nonatomic) CGFloat maxX;
/** UIView的最大Y值 */
@property (assign, nonatomic) CGFloat maxY;

/** UIView 的宽度 */
@property (nonatomic, assign) CGFloat width;
/** UIView 的高度 */
@property (nonatomic, assign) CGFloat height;

/** UIView 的 size */
@property (nonatomic, assign) CGSize size;
/** UIView 的坐标 */
@property (nonatomic, assign) CGPoint origin;

/** UIView 的宽度 bounds */
@property (nonatomic, assign) CGFloat boundsWidth;

/** UIView 的高度 bounds */
@property (nonatomic, assign) CGFloat boundsHeight;

/**
 *  9.上 < Shortcut for frame.origin.y
 */
@property (nonatomic) CGFloat top;

/**
 *  10.下 < Shortcut for frame.origin.y + frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 *  11.左 < Shortcut for frame.origin.x.
 */
@property (nonatomic) CGFloat left;

/**
 *  12.右 < Shortcut for frame.origin.x + frame.size.width
 */
@property (nonatomic) CGFloat right;

//截取成图片
- (UIImage *)snapshotImage;

/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)addTapActionWithBlock:(TapActionBlock)block;

/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)addLongPressActionWithBlock:(LongPressActionBlock)block;

/** 找到指定类名的subView */
- (UIView *)findSubViewWithClass:(Class)clazz;
- (NSArray *)findAllSubViewsWithClass:(Class)clazz;

/** 找到指定类名的superView对象 */
- (UIView *)findSuperViewWithClass:(Class)clazz;

/** 找到view上的第一响应者 */
- (UIView *)findFirstResponder;

/** 找到当前view所在的viewcontroler */
- (UIViewController *)findViewController;

//所有子视图
- (NSArray *)allSubviews;

//移除所有子视图
- (void)removeAllSubviews;

//xib加载视图
+ (instancetype)loadViewFromNib;
+ (instancetype)loadViewFromNibWithName:(NSString *)nibName;
+ (instancetype)loadViewFromNibWithName:(NSString *)nibName owner:(id)owner;
+ (instancetype)loadViewFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;

/**
 * 给UIView 设置圆角
 */
@property (assign,nonatomic) IBInspectable NSInteger cornerRadius;
@property (assign,nonatomic) IBInspectable BOOL  masksToBounds;

/**
 * 设置 view的 边框颜色(选择器和Hex颜色)
 * 以及 边框的宽度
 */
@property (assign,nonatomic) IBInspectable NSInteger borderWidth;
@property (strong,nonatomic) IBInspectable NSString  *borderHexRgb;
@property (strong,nonatomic) IBInspectable UIColor   *borderColor;


/**
 设置view 梯度渲染

 @param startColor 开始颜色
 @param endColor 结束颜色
 @param direction 梯度方向 默认横向
 */
- (CAGradientLayer *)setGradientLayerWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor direction:(GradientLayerDirection)direction;


/**
 判断 view 是否在屏幕中

 @return 是否在屏幕中
 */
- (BOOL)isDisplayedInScreen;

@end
