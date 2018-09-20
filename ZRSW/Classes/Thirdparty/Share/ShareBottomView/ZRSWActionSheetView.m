//
//  ZRSWActionSheetView.m
//  ZRSW
//
//  Created by King on 2018/9/20.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWActionSheetView.h"
#import "ZRSWShareTableViewCell.h"
#define SafeAreaHeight ((SCREEN_WIDTH-812)?0:34)
#define SPACE 10
#define SheetViewHeight 189
#define ActionViewHeight 45

@interface ZRSWActionSheetView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,   copy) NSString *cancelTitle;
@property (nonatomic, strong) NSMutableArray * buttonsArr;
@end

@implementation ZRSWActionSheetView

-(instancetype)initAtionSheetView{
    if (self = [super init]) {
        [self craetUI];
    }
    return self;
}

- (void)craetUI {
    self.buttonsArr =[[NSMutableArray alloc]initWithCapacity:0];
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
}


- (UIView*)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorFromRGB:0xFF000000];
        _maskView.alpha = .0;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 10;
        _tableView.clipsToBounds = YES;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled =NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;

}
#pragma mark TableViewDel
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        return kUI_HeightS(SheetViewHeight);
    }else{
        return kUI_HeightS(ActionViewHeight);
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        ZRSWShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"top_Cell"];
        if (!cell){
            cell=[[ZRSWShareTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"top_Cell"];
        }
        cell.backgroundColor=[UIColor colorFromRGB:0xFFFFFF];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.cornerRadius = 10;
        [cell.shareBtn1 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareBtn2 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareBtn3 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareBtn4 addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsArr addObject:cell.shareBtn1];
        [self.buttonsArr addObject:cell.shareBtn2];
        [self.buttonsArr addObject:cell.shareBtn3];
        [self.buttonsArr addObject:cell.shareBtn4];
        [self.buttonsArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [UIView animateWithDuration:1.1 delay:0.05 * (idx +1) usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                obj.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
            }];
        }];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottom_Cell"];
        if (!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bottom_Cell"];
        }
        cell.backgroundColor=[UIColor colorFromRGB:0xFFFFFF];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"取消";
        cell.textLabel.textColor = [UIColor colorFromRGB:0xFF007AFF];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.layer.cornerRadius = 10;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SPACE;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, SPACE)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self show];
}


-(void)shareBtnClick:(ZRSWActionSheetButton *)btn{
    if ([_delegate respondsToSelector:@selector(customActionSheetButtonClick:)]) {
        [_delegate customActionSheetButtonClick:btn];

    }
    [self dismiss];
}

- (void)show {
    _tableView.frame = CGRectMake(SPACE, SCREEN_HEIGHT -(SPACE * 2), SCREEN_WIDTH - (SPACE * 2), kUI_HeightS(SheetViewHeight + ActionViewHeight)+(SPACE * 2));
    WS(weakSelf);
    [UIView animateWithDuration:.35 animations:^{
        weakSelf.maskView.alpha = .65;
        CGRect rect = weakSelf.tableView.frame;
        rect.origin.y -= weakSelf.tableView.bounds.size.height;
        //适配iPhone X
        rect.origin.y -= SafeAreaHeight;
        weakSelf.tableView.frame = rect;
    }];
}

- (void)dismiss {
    WS(weakSelf);
    [UIView animateWithDuration:.15 animations:^{
        weakSelf.maskView.alpha = .0;
        CGRect rect = weakSelf.tableView.frame;
        rect.origin.y += weakSelf.tableView.bounds.size.height;
        //适配iPhone X
        rect.origin.y += SafeAreaHeight;
        weakSelf.tableView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

@end
