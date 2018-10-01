//
//  ZRSWShareTableViewCell.m
//  ZRSW
//
//  Created by King on 2018/9/20.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWShareTableViewCell.h"
#import "ZRSWShareManager.h"
@implementation ZRSWShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        //分享到
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"分享至";
        titleLabel.font = [UIFont systemFontOfSize:23];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor =[UIColor colorFromRGB:0x474455];
        titleLabel.frame = CGRectMake(0, kUI_HeightS(17), SCREEN_WIDTH-20, 23);
        [self addSubview:titleLabel];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor =  [UIColor colorFromRGB:0xFFC8C8C8];
        lineView.frame = CGRectMake(2, kUI_HeightS(57), SCREEN_WIDTH-24, 1);
        [self addSubview:lineView];
        CGFloat btnW = 84;
        CGFloat btnH = 90;
        BOOL wxavailable = [ZRSWShareManager isInstallWeChat];
        BOOL qqavailable = [ZRSWShareManager isInstallQQ];
        BOOL wbavailable = [ZRSWShareManager isImstallWeiBo];
        NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:0];
        if (wxavailable) {
            [contentArray addObject:@{@"name":@"微信好友",@"icon":@"share_wechat"}];
            if (qqavailable) {
                [contentArray addObject:@{@"name":@"QQ好友",@"icon":@"share_qq"}];
            }
            [contentArray addObject:@{@"name":@"朋友圈",@"icon":@"share_friends"}];
            if (wbavailable) {
                 [contentArray addObject:@{@"name":@"新浪微博",@"icon":@"share_blog"}];
            }
        }else{
            if (qqavailable) {
                [contentArray addObject:@{@"name":@"QQ好友",@"icon":@"share_qq"}];
            }
            if (wbavailable) {
                [contentArray addObject:@{@"name":@"新浪微博",@"icon":@"share_blog"}];
            }
        }
        for (int i = 0; i < contentArray.count; i++)
        {
            NSDictionary *dic = [contentArray objectAtIndex:i];
            NSString *name = dic[@"name"];
            NSString *icon = dic[@"icon"];
            ZRSWActionSheetButton *btn = [ZRSWActionSheetButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [btn setTitle:name forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
            CGFloat marginX = (SCREEN_WIDTH-20 - 4 * btnW) / (4 + 1);
            int col = i % 4;
            CGFloat btnX = marginX + (marginX + btnW) * col;
            btn.frame = CGRectMake(btnX,kUI_HeightS(80), btnW, btnH);
            btn.transform = CGAffineTransformMakeTranslation(0, 100);
            switch (i) {
                case 0:
                {
                    self.shareBtn1=btn;

                }
                    break;
                case 1:
                {

                    self.shareBtn2=btn;
                }
                    break;
                case 2:
                {
                    self.shareBtn3=btn;
                }
                    break;
                case 3:
                {
                    self.shareBtn4=btn;
                }
                    break;

                default:
                    break;
            }
            [self addSubview:btn];
        }
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
