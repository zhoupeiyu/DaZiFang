//
//  ZRSWLinePrejudicationCells.m
//  ZRSW
//
//  Created by 周培玉 on 2018/10/1.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWLinePrejudicationCells.h"

#pragma mark - 用户信息
// 选择性别
@interface LinePrejudicationUserInfoCheckItem ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *manBtn;
@property (nonatomic, strong) UIButton *womanBtn;
@property (nonatomic, assign) UseInfoSex defaultSex;

@end

@implementation LinePrejudicationUserInfoCheckItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
        [self setupUI];
    }
    return self;
}

- (void)setupConfig {
    self.backgroundColor = [UIColor whiteColor];
}
- (void)setupUI {
    [self addSubview:self.titleLbl];
    [self addSubview:self.lineView];
    [self addSubview:self.manBtn];
    [self addSubview:self.womanBtn];
    
    [self setupLayout];
}

- (void)setupLayout {
    CGFloat titleLblX = 15;
    CGFloat inputTextFieldX = 140;
    CGFloat titleLblW = inputTextFieldX - titleLblX - 5;
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLblX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(titleLblW);
    }];
    [self.manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inputTextFieldX + 8);
        make.top.bottom.mas_equalTo(0);
    }];
    [self.womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.manBtn.mas_right).offset(30);
        make.top.bottom.mas_equalTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLblX);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-titleLblX);
        make.height.mas_equalTo(KSeparatorLineHeight);
    }];
}

- (void)setTitle:(NSString *)title {
    NSString *titleStr = [NSString stringWithFormat:@"*%@",title];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSRangeMake(0, title.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0x474455] range:NSRangeMake(0, title.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0xff0000] range:NSRangeMake(0, 1)];
    self.titleLbl.attributedText = attr;
    [self.titleLbl sizeToFit];
}
- (void)setDefaultSex:(UseInfoSex)sex {
    UIButton *btn = self.manBtn;
    if (sex == UseInfoSexMan) {
        btn = self.manBtn;
    }
    else {
        btn = self.womanBtn;
    }
    _defaultSex = sex;
    [self sexAction:btn];
}
- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    self.lineView.hidden = bottomLineHidden;
}
- (void)sexAction:(UIButton *)btn {
    self.manBtn.selected = btn.tag == UseInfoSexMan;
    self.womanBtn.selected = btn.tag == UseInfoSexWoman;
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkViewSelectedNum:)]) {
        [self.delegate checkViewSelectedNum:btn.tag];
    }
}

#pragma mark - lazy
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor colorFromRGB:0x474455];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.font = [UIFont systemFontOfSize:14];
    }
    return _titleLbl;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [ZRSWViewFactoryTool getLineView];
    }
    return _lineView;
}
- (UIButton *)manBtn {
    if (!_manBtn) {
        _manBtn = [self getSexBtn:@"男"];
        _manBtn.tag = UseInfoSexMan;
    }
    return _manBtn;
}
- (UIButton *)womanBtn {
    if (!_womanBtn) {
        _womanBtn = [self getSexBtn:@"女"];
        _womanBtn.tag = UseInfoSexWoman;
    }
    return _womanBtn;
}
- (UIButton *)getSexBtn:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromRGB:0x999999] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromRGB:0x666666] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"pretrial_sex_default"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"pretrial_sex_select"] forState:UIControlStateSelected];
    [btn jk_setImagePosition:LXMImagePositionLeft spacing:10];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(sexAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end

// 输入文本
@interface LinePrejudicationUserInfoInputItem ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIView *lineView;

@end
@implementation LinePrejudicationUserInfoInputItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
        [self setupUI];
    }
    return self;
}

- (void)setupConfig {
    self.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.inputTextField];
}
- (void)setupUI {
    [self addSubview:self.titleLbl];
    [self addSubview:self.inputTextField];
    [self addSubview:self.lineView];
    
    [self setupLayout];
}

- (void)setupLayout {
    CGFloat titleLblX = 15;
    CGFloat inputTextFieldX = 140;
    CGFloat titleLblW = inputTextFieldX - titleLblX - 5;
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLblX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(titleLblW);
    }];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-titleLblX);
        make.left.mas_equalTo(inputTextFieldX);
        make.top.bottom.mas_equalTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLblX);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-titleLblX);
        make.height.mas_equalTo(KSeparatorLineHeight);
    }];
}
- (void)textFieldTextDidChange:(NSNotification *)noti {
    if (noti.object == self.inputTextField) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldTextDidChange:customView:)]) {
            [self.delegate textFieldTextDidChange:self.inputTextField customView:self];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:customView:)]) {
        BOOL isInput = [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string customView:self];
        return isInput;
    }
    return YES;
}
- (void)setTitle:(NSString *)title {
    NSString *titleStr = [NSString stringWithFormat:@"*%@",title];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSRangeMake(0, title.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0x474455] range:NSRangeMake(0, title.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0xff0000] range:NSRangeMake(0, 1)];
    self.titleLbl.attributedText = attr;
    [self.titleLbl sizeToFit];
}
- (void)setPlaceHolder:(NSString *)placeHolder {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:placeHolder];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSRangeMake(0, placeHolder.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0x999999] range:NSRangeMake(0, placeHolder.length)];
    self.inputTextField.attributedPlaceholder = attr;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.inputTextField.keyboardType = keyboardType;
}
- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    self.lineView.hidden = bottomLineHidden;
}
#pragma mark - lazy
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor colorFromRGB:0x474455];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.font = [UIFont systemFontOfSize:14];
    }
    return _titleLbl;
}
- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.textAlignment = NSTextAlignmentLeft;
        _inputTextField.font = [UIFont systemFontOfSize:14];
        _inputTextField.textColor = [UIColor colorFromRGB:0x474455];
        _inputTextField.clearsOnBeginEditing = YES;
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextField.keyboardType = UIKeyboardTypeDefault;
        _inputTextField.delegate = self;
    }
    return _inputTextField;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [ZRSWViewFactoryTool getLineView];
    }
    return _lineView;
}
@end

@interface LinePrejudicationUserInfoCell ()<LinePrejudicationInputItemDelegate,LinePrejudicationCheckItemDelegate>

@property (nonatomic, strong) LinePrejudicationUserInfoInputItem *personLbl;
@property (nonatomic, strong) LinePrejudicationUserInfoCheckItem *checkItem;
@property (nonatomic, strong) LinePrejudicationUserInfoInputItem *cityLbl;
@property (nonatomic, strong) LinePrejudicationUserInfoInputItem *phoneLbl;
@property (nonatomic, strong) LinePrejudicationUserInfoInputItem *moneyLbl;

@property (nonatomic, assign) UseInfoSex currentSex;
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *moneyNum;

@end

@implementation LinePrejudicationUserInfoCell

+ (LinePrejudicationUserInfoCell *)getCellWithTableView:(UITableView *)tableView {
    LinePrejudicationUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (!cell) {
        cell = [[LinePrejudicationUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self)];
    }
    return cell;
}
+ (CGFloat)cellHeight {
    return 230;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupConfig];
        [self setupUI];
    }
    return self;
}

- (void)setupConfig {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setupUI {
    [self.contentView addSubview:self.personLbl];
    [self.contentView addSubview:self.checkItem];
    [self.contentView addSubview:self.cityLbl];
    [self.contentView addSubview:self.phoneLbl];
    [self.contentView addSubview:self.moneyLbl];
    [self setupLayout];
}
- (void)setupLayout {
    CGFloat itemH = [LinePrejudicationUserInfoCell cellHeight] / 5;
    [self.personLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(itemH);
    }];
    [self.checkItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.personLbl.mas_bottom);
        make.height.mas_equalTo(itemH);
    }];
    [self.cityLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.checkItem.mas_bottom);
        make.height.mas_equalTo(itemH);
    }];
    [self.phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.cityLbl.mas_bottom);
        make.height.mas_equalTo(itemH);
    }];
    [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.phoneLbl.mas_bottom);
        make.height.mas_equalTo(itemH);
    }];
}
- (NSString *)loanPersonName {
    return @"";
}
- (NSString *)loanPersonSex {
    return [NSString stringWithFormat:@"%zd",self.currentSex];
}
- (NSString *)loanPersonAdd {
    return @"";
}
- (NSString *)loanPersonPhone {
    return @"";
}
- (NSString *)loanPersonMoney {
    return @"";
}

#pragma mark - delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string customView:(LinePrejudicationUserInfoInputItem *)customView {
    if (customView == self.moneyLbl) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 65) return NO; //
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
        }
        return YES;
    }
    else if (customView == self.phoneLbl) {
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) {
            return NO;//限制长度
        }
    }
    return YES;
}

- (void)textFieldTextDidChange:(UITextField *)textField customView:(LinePrejudicationUserInfoInputItem *)customView {
    if (customView == self.personLbl) {
        self.personName = textField.text;
    }
    else if (customView == self.cityLbl) {
        self.cityName = textField.text;
    }
    else if (customView == self.phoneLbl) {
        self.phoneNum = textField.text;
    }
    else if (customView == self.moneyLbl) {
        self.moneyNum = textField.text;
    }
}

- (void)checkViewSelectedNum:(UseInfoSex)sex {
    self.currentSex = sex;
}
#pragma mark - lazy

- (LinePrejudicationUserInfoInputItem *)personLbl {
    if (!_personLbl) {
        _personLbl = [[LinePrejudicationUserInfoInputItem alloc] init];
        [_personLbl setTitle:@"贷款人姓名"];
        [_personLbl setPlaceHolder:@"请输入实际贷款人姓名"];
        [_personLbl setKeyboardType:UIKeyboardTypeDefault];
        [_personLbl setBottomLineHidden:NO];
        [_personLbl setDelegate:self];
    }
    return _personLbl;
}
- (LinePrejudicationUserInfoCheckItem *)checkItem {
    if (!_checkItem) {
        _checkItem = [[LinePrejudicationUserInfoCheckItem alloc] init];
        [_checkItem setTitle:@"贷款人性别"];
        [_checkItem setBottomLineHidden:NO];
        [_checkItem setDelegate:self];
        [_checkItem setDefaultSex:UseInfoSexMan];
    }
    return _checkItem;
}
- (LinePrejudicationUserInfoInputItem *)cityLbl {
    if (!_cityLbl) {
        _cityLbl = [[LinePrejudicationUserInfoInputItem alloc] init];
        [_cityLbl setTitle:@"贷款人所在区域"];
        [_cityLbl setPlaceHolder:@"请输入实际贷款人所在区域"];
        [_cityLbl setKeyboardType:UIKeyboardTypeDefault];
        [_cityLbl setBottomLineHidden:NO];
        [_cityLbl setDelegate:self];
    }
    return _cityLbl;
}
- (LinePrejudicationUserInfoInputItem *)phoneLbl {
    if (!_phoneLbl) {
        _phoneLbl = [[LinePrejudicationUserInfoInputItem alloc] init];
        [_phoneLbl setTitle:@"贷款人电话"];
        [_phoneLbl setPlaceHolder:@"请输入实际贷款人电话"];
        [_phoneLbl setKeyboardType:UIKeyboardTypePhonePad];
        [_phoneLbl setBottomLineHidden:NO];
        [_phoneLbl setDelegate:self];
    }
    return _phoneLbl;
}
- (LinePrejudicationUserInfoInputItem *)moneyLbl {
    if (!_moneyLbl) {
        _moneyLbl = [[LinePrejudicationUserInfoInputItem alloc] init];
        [_moneyLbl setTitle:@"贷款金额"];
        [_moneyLbl setPlaceHolder:@"请输入贷款人金额"];
        [_moneyLbl setKeyboardType:UIKeyboardTypeNumberPad];
        [_moneyLbl setBottomLineHidden:YES];
        [_moneyLbl setDelegate:self];
    }
    return _moneyLbl;
}
@end

#pragma mark - 备注

@interface LinePrejudicationRemarksCell ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation LinePrejudicationRemarksCell

+ (LinePrejudicationRemarksCell *)getCellWithTableView:(UITableView *)tableView {
    LinePrejudicationRemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (!cell) {
        cell = [[LinePrejudicationRemarksCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self)];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupConfig];
        [self setupUI];
    }
    return self;
}

- (void)setupConfig {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setupUI {
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
}
- (NSString *)remarkText {
    return self.textView.text;
}
+ (CGFloat)cellHeight {
    return 120;
}
#pragma mark - lazy
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = [UIColor colorFromRGB:0x474455];
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.textAlignment = NSTextAlignmentLeft;
        [_textView jk_addPlaceHolder:@"备注信息"];
        //[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _textView.backgroundColor = [UIColor colorFromRGB:0xF9F9F9];
        _textView.layer.cornerRadius = 8;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}
@end
