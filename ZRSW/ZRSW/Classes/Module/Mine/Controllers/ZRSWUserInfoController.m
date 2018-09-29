//
//  ZRSWUserInfoController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWUserInfoController.h"
#import "ZRSWUserInfoCell.h"
#import "ZRSWUserInfoListModel.h"
#import <objc/message.h>
#import "UserService.h"

typedef enum : NSUInteger {
    InputTextFieldTypeName = 100000,
    InputTextFieldTypeMyID
} InputTextFieldType;
@interface ZRSWUserInfoController ()<UserInfoCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSouce;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UploadImagesManager *imageManager;
@property (nonatomic, strong) NSMutableArray *selectedImages;
@property (nonatomic, strong) UserService *service;
@property (nonatomic, strong) NSString *myID;
@property (nonatomic, assign) BOOL isCanChangeMyID;

@end

@implementation ZRSWUserInfoController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = @"基础消息";
    self.isCanChangeMyID = [UserModel getCurrentModel].data.myId.length == 0;
    [self setRightBarButtonWithText:@"保存"];
    [self.rightBarButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupUI {
    [super setupUI];
    
}
- (void)saveAction {
    [self.tableView endEditing:YES];
    [self.view endEditing:YES];
    WS(weakSelf);
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoading];
        NSString *url = self.selectedImages.count > 0 ? self.selectedImages.firstObject : @"";
        if (self.name.length == 0) {
            [TipViewManager showToastMessage:@"请输入昵称！"];
            return;
        }
        if (self.isCanChangeMyID) {
            if (self.myID.length == 0) {
                [TipViewManager showToastMessage:@"请输入掮客号！"];
                return;
            }
        }
        [weakSelf.service updateUserInfoMyId:self.myID nickName:self.name headImgUrl:url email:nil delegate:self];
    }
}

- (void)uploadHeadImage {
    WS(weakSelf);
    [[PhotoManager sharedInstance] showPhotoPickForMaxCount:1 presentedViewController:self photoPickType:PhotoPickTypeSystem complete:^(NSMutableArray *selectedImages) {
        if ([TipViewManager showNetErrorToast]) {
            [TipViewManager showLoading];
            __block ZRSWUserInfoListModel *model = self.dataSouce[0][0];
            [self.imageManager uploadImagesWithImagesArray:selectedImages completeBlock:^(NSMutableArray * _Nullable imageUrls) {
                UserModel *userModel = [UserModel getCurrentModel];
                userModel.data.headImgUrl = imageUrls.firstObject;
                [UserModel updateUserModel:userModel];
                [TipViewManager dismissLoading];
                weakSelf.selectedImages = imageUrls;
                model.image = selectedImages.firstObject;
                [weakSelf.tableView reloadData];
            }];
        }
    }];
}


#pragma mark - delegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataSouce[section];
    return arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSouce.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZRSWUserInfoCell *cell = [ZRSWUserInfoCell getCellWithTableView:tableView];
    ZRSWUserInfoListModel *model = self.dataSouce[indexPath.section][indexPath.row];
    [cell setUserInfoListModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.0001 : 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [BaseTheme baseViewColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZRSWUserInfoListModel *mineModel = ((NSMutableArray *)self.dataSouce[indexPath.section])[indexPath.row];
    return mineModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZRSWUserInfoListModel *mineModel = ((NSMutableArray *)self.dataSouce[indexPath.section])[indexPath.row];
    if (mineModel.actionName.length > 0) {
        SEL action = NSSelectorFromString(mineModel.actionName);
        [self sendNewObjcMsg:self selector:action withObj:nil];
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string customView:(ZRSWUserInfoCell *)cell {
    
    return YES;
}

- (void)textFieldTextDidChange:(UITextField *)textField customView:(ZRSWUserInfoCell *)cell {
    if (textField.tag == InputTextFieldTypeName) {
        self.name = textField.text;
    }
    else if (textField.tag == InputTextFieldTypeMyID) {
        self.myID = textField.text;
    }
}
- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        UserModel *model = (UserModel *)resObj;
        if (model.error_code.integerValue == 0) {
            [TipViewManager showToastMessage:@"更新用户信息成功！"];
            model.data.myId = self.myID;
            model.data.nickName = self.name;
            [UserModel updateUserModel:model];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            [TipViewManager showToastMessage:model.error_msg];
        }
    }
    else {
        [TipViewManager showToastMessage:@"更新失败！"];
    }
}

#pragma mark - lazy

- (NSMutableArray *)dataSouce {
    if (!_dataSouce) {
        _dataSouce = [[NSMutableArray alloc] init];
        UserModel *userModel = [UserModel getCurrentModel];
        {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            {
                ZRSWUserInfoListModel *model = [[ZRSWUserInfoListModel alloc] init];
                model.bottomLineHidden = YES;
                model.cellType = UserInfoCellTypeHeader;
                model.title = @"头像";
                model.desTitle = @"";
                model.actionName = @"uploadHeadImage";
                model.headerImageUrl = userModel.data.headImgUrl;
                [arr addObject:model];
            }
            [_dataSouce addObject:arr];
        }
        {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            {
                ZRSWUserInfoListModel *model = [[ZRSWUserInfoListModel alloc] init];
                model.bottomLineHidden = NO;
                model.cellType = UserInfoCellTypeInput;
                model.title = @"昵称:";
                model.placeHoled = @"请输入昵称";
                model.desTitle = userModel.data.nickName;
                self.name = userModel.data.nickName;
                model.deleget = self;
                model.textFieldTag = InputTextFieldTypeName;
                model.selectionStyle = UITableViewCellSelectionStyleNone;
                [arr addObject:model];
            }
            {
                ZRSWUserInfoListModel *model = [[ZRSWUserInfoListModel alloc] init];
                model.bottomLineHidden = YES;
                model.cellType = self.isCanChangeMyID ? UserInfoCellTypeInput : UserInfoCellTypeInfo;
                model.title = @"掮客号:";
                model.desTitle = userModel.data.myId;
                model.deleget = self;
                model.textFieldTag = InputTextFieldTypeMyID;
                self.myID = userModel.data.myId;
                model.selectionStyle = UITableViewCellSelectionStyleNone;
                [arr addObject:model];
            }
            [_dataSouce addObject:arr];
        }
        
    }
    return _dataSouce;
}
- (UploadImagesManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [UploadImagesManager sharedInstance];
        _imageManager.imageType = UploadImageTypeJpg;
        _imageManager.name = @"file";
        _imageManager.url = @"api/user/uploadFile";
    }
    return _imageManager;
}
- (UserService *)service {
    if (!_service) {
        _service = [[UserService alloc] init];
    }
    return _service;
}
- (void)sendNewObjcMsg:(id)target selector:(SEL)sel withObj:(id)obj {
    if (![target respondsToSelector:sel]) {
        return;
    }
    if (obj) {
        void(*objc_msgSendTyped)(id self, SEL _cmd, id _ddservice) = (void*)objc_msgSend;
        objc_msgSendTyped(target, sel, obj);
    }
    else{
        void(*objc_msgSendTyped)(id self, SEL _cmd) = (void*)objc_msgSend;
        objc_msgSendTyped(target, sel);
    }
}

@end
