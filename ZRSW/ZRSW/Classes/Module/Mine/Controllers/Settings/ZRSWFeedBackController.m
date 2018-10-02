//
//  ZRSWFeedBackController.m
//  ZRSW
//
//  Created by King on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWFeedBackController.h"
#import "UserService.h"
#define MaxNumberOfWord 200
@interface ZRSWFeedBackController ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *feedBackView;
@property (nonatomic, strong) UITextView *feedBackTextView;
@property (nonatomic, strong) UILabel *numWordLable;
@property (nonatomic, strong) UIButton *commitButton;
@end

@implementation ZRSWFeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.navigationItem.title = @"意见反馈";
    [self.scrollView addSubview:self.feedBackView];
    [self.scrollView addSubview:self.commitButton];
}



#pragma mark textView代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([[textView text] length]>MaxNumberOfWord){
        return NO;
    }else{
        NSInteger interNumWord = [[textView text] length];
        self.numWordLable.text=[NSString stringWithFormat:@"%ld/%d",(long)interNumWord,MaxNumberOfWord];
        if (interNumWord == 0) {
            self.commitButton.enabled = NO;
        }else{
            self.commitButton.enabled = YES;
        }
        return YES;
    }
}


-(void)textViewDidChange:(UITextView *)textView{
    NSInteger interNumWord=0;
    if (textView.text.length > MaxNumberOfWord){
        textView.text = [textView.text substringToIndex:MaxNumberOfWord];
        interNumWord=MaxNumberOfWord;
    }else{
        interNumWord = [[textView text] length];
    }
    self.numWordLable.text=[NSString stringWithFormat:@"%ld/%d",(long)interNumWord,MaxNumberOfWord];
    if (interNumWord == 0) {
        self.commitButton.enabled = NO;
    }else{
        self.commitButton.enabled = YES;
    }
}

- (UIView *)feedBackView{
    if (!_feedBackView) {
        _feedBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kUI_HeightS(10), SCREEN_WIDTH, kUI_HeightS(211))];
        _feedBackView.backgroundColor = [UIColor colorFromRGB:0xFFFFFF];
        [_feedBackView addSubview:self.feedBackTextView];
        [_feedBackView addSubview:self.numWordLable];
    }
    return _feedBackView;
}

- (UITextView *)feedBackTextView{
    if (!_feedBackTextView) {
        _feedBackTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, kUI_HeightS(0), SCREEN_WIDTH, kUI_HeightS(188))];
        [_feedBackTextView jk_addPlaceHolder:@"告诉我们你的小建议，让我们为您提供更好的服务" ];
        _feedBackTextView.font = [UIFont systemFontOfSize:15];
        _feedBackTextView.textColor = [UIColor colorFromRGB:0XD000000];
        _feedBackTextView.delegate = self;
    }
    return _feedBackTextView;
}

- (UILabel *)numWordLable{
    if (!_numWordLable) {
        _numWordLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -kUI_WidthS(102) , self.feedBackTextView.bottom, kUI_WidthS(88), kUI_HeightS(14))];
        _numWordLable.text=[NSString stringWithFormat:@"0/%d",MaxNumberOfWord];
        _numWordLable.textColor = [UIColor colorFromRGB:0xFFB9B9B9];
        _numWordLable.textAlignment = NSTextAlignmentRight;
        _numWordLable.font = [UIFont systemFontOfSize:14];
    }
    return _numWordLable;
}
- (UIButton *)commitButton{
    if (!_commitButton) {
        _commitButton = [[UIButton alloc] initWithFrame:CGRectMake(kUI_WidthS(30) ,kUI_HeightS(246), SCREEN_WIDTH - kUI_WidthS(60), kUI_HeightS(44))];
        [_commitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromRGB:0x4771F2]] forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromRGB:0x2341BF]] forState:UIControlStateHighlighted];
        [_commitButton.layer setCornerRadius:5.0];
        [_commitButton.layer setMasksToBounds:YES];
        [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor colorFromRGB:0xFFFFFF] forState:UIControlStateNormal];
        _commitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commitButton addTarget:self action:@selector(commitButtonClck:) forControlEvents:UIControlEventTouchUpInside];
        _commitButton.enabled = NO;
    }
    return _commitButton;
}

- (void)commitButtonClck:(UIButton *)button{
    LLog(@"提交");
    [self.view endEditing:YES];
    [[[UserService alloc] init] userFeedBack:self.feedBackTextView.text delegate:self];
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KUserFeedBackRequest]) {
            BaseModel *model = (BaseModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [TipViewManager showToastMessage:@"意见反馈成功!"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
