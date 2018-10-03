//
//  ZRSWLinePrejudicationCells.m
//  ZRSW
//
//  Created by 周培玉 on 2018/10/1.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWLinePrejudicationCells.h"

#pragma mark - r图片cell

#define defaultMaxNum 9
static CGFloat leftAndRightMargin = 15;
static NSString * const cellIdentifier = @"photo";


@implementation LinePrejudicationImagesModel

@end

@interface LinePrejudicationImagesView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger maxPickerImageNum;

@end
@implementation LinePrejudicationImagesView

+ (LinePrejudicationImagesView *)getImagesView {
    LinePrejudicationImagesView *view = [[LinePrejudicationImagesView alloc] init];
    return view;
}
- (NSMutableArray *)getResultImages {
    [self.selectedImages removeAllObjects];
    for (LinePrejudicationImagesModel *model in self.dataSource) {
        [self.selectedImages addObject:model.image];
    }
    return self.selectedImages;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpConfig];
        [self setUpUI];
    }
    return self;
}


- (void)setUpConfig {
    [self addFristImage];
    self.maxPickerImageNum = defaultMaxNum;
}
- (void)setUpUI {
    [self addSubview:self.collectionView];
    [self.collectionView reloadData];
}
+ (CGFloat)viewHeight {
    return 80;
}
#pragma mark - delegate && dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource.count >= self.maxPickerImageNum) {
        return self.dataSource.count;
    }
    return _dataSource.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    for (UIView * subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 2;
    imageView.layer.masksToBounds = YES;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:imageView];
    
    UIButton * cancelButton = [[UIButton alloc] init];
    [cancelButton setImage:[UIImage imageNamed:@"btn_deleted_img_normal"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"btn_deleted_img_pressed"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = indexPath.item;
    cancelButton.hidden = indexPath.item == 0;
    [cell.contentView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(imageView.mas_right).offset(7);
        make.top.mas_equalTo(imageView.mas_top).offset(-7);
    }];
    
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseButton setImage:[UIImage imageNamed:@"pretrial_upload_button"] forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(choosePicture) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:chooseButton];
    [chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(80, 70));
    }];
    if (indexPath.row >= _dataSource.count) {
        imageView.hidden = YES;
        cancelButton.hidden = YES;
        chooseButton.hidden = NO;
    }else{
        LinePrejudicationImagesModel *model = self.dataSource[indexPath.item];
        imageView.image = model.image;
        imageView.hidden = NO;
        cancelButton.hidden = NO;
        chooseButton.hidden = YES;
    }
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 60);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(0, leftAndRightMargin , 0, leftAndRightMargin);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= _dataSource.count) {
        [self choosePicture];
        return;
    }
}
#pragma mark - event

- (void)choosePicture {
    NSUInteger maxImageCount = self.maxPickerImageNum - self.dataSource.count;
    WS(weakSelf);
    [[PhotoManager sharedInstance] showPhotoPickForMaxCount:maxImageCount presentedViewController:self.presentedVC photoPickType:PhotoPickTypeSystem complete:^(NSMutableArray *selectedImages) {
        for (UIImage *image in selectedImages) {
            LinePrejudicationImagesModel *model = [[LinePrejudicationImagesModel alloc] init];
            model.image = image;
            [weakSelf.dataSource addObject:model];
            [weakSelf.collectionView reloadData];
        }
    }];
}

- (void)cancelButtonOnClick:(UIButton *)sender{
    [_dataSource removeObjectAtIndex:sender.tag];
    [_collectionView reloadData];
}

- (void)addFristImage {
    
}
#pragma mark - lazy

- (NSMutableArray *)selectedImages {
    if (!_selectedImages) {
        _selectedImages = [[NSMutableArray alloc] init];
    }
    return _selectedImages;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        
    }
    return _dataSource;
}
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [LinePrejudicationImagesView viewHeight]) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        _collectionView.clipsToBounds = false;
    }
    return _collectionView;
}

@end


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

@interface LinePrejudicationUserInfoView ()<LinePrejudicationInputItemDelegate,LinePrejudicationCheckItemDelegate>

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

@implementation LinePrejudicationUserInfoView

+ (LinePrejudicationUserInfoView *)getUserInfoView {
    LinePrejudicationUserInfoView *view = [[LinePrejudicationUserInfoView alloc] init];
    return view;
}
+ (CGFloat)viewHeight {
    return 230;
}
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
    [self addSubview:self.personLbl];
    [self addSubview:self.checkItem];
    [self addSubview:self.cityLbl];
    [self addSubview:self.phoneLbl];
    [self addSubview:self.moneyLbl];
    [self setupLayout];
}
- (void)setupLayout {
    CGFloat itemH = [LinePrejudicationUserInfoView viewHeight] / 5;
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
    return self.personName;
}
- (NSString *)loanPersonSex {
    return [NSString stringWithFormat:@"%zd",self.currentSex];
}
- (NSString *)loanPersonAdd {
    return self.cityName;
}
- (NSString *)loanPersonPhone {
    return self.phoneNum;
}
- (NSString *)loanPersonMoney {
    return self.moneyNum;
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
        if (proposedNewLength > 12) {
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

@interface LinePrejudicationRemarksView ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation LinePrejudicationRemarksView

+ (LinePrejudicationRemarksView *)getRemarkView {
    LinePrejudicationRemarksView *remarkView = [[LinePrejudicationRemarksView alloc] init];
    return remarkView;
}
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
    [self addSubview:self.textView];
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
+ (CGFloat)viewHeight {
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
