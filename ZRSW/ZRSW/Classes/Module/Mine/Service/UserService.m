//
//  UserService.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/12.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "UserService.h"


@implementation UserService

- (NSString *)typeStr:(ImageCodeType)imageCodeType {
    NSString *imageType = @"register";
    if (imageCodeType == ImageCodeTypeRegister) {
        imageType = @"register";
    }else if (imageCodeType == ImageCodeTypePwd) {
        imageType = @"pwd";
    }
    else if (imageCodeType == ImageCodeTypeResetPhone) {
        imageType = @"resetPhone";
    }
    else if (imageCodeType == ImageCodeTypeResetPhone2) {
        imageType = @"resetPhone2";
    }
    return imageType;
}
- (void)getUserImageCode:(ImageCodeType)imageCodeType delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self typeStr:imageCodeType] forKey:@"type"];
    [self POST:KGetImageCodeInterface reqType:KGetImageCodeRequest delegate:delegate parameters:params ObjcClass:[GetUserImageCodeModel class] NeedCache:NO];
    
}

- (void)getUserPhoneCode:(ImageCodeType)imageCodeType phone:(NSString *)phone delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self typeStr:imageCodeType] forKey:@"type"];
    [params setObject:phone forKey:@"phone"];
    NSString *type = KGetPhoneCodeRequest;
    if (imageCodeType == ImageCodeTypeResetPhone) {
        type = KGetNewPhoneCodeRequest;
    }else if(imageCodeType == ImageCodeTypeResetPhone2){
        type = KGetOldPhoneCodeRequest;
    }
    [self POST:KGetPhoneCodeInterface reqType:type delegate:delegate parameters:params ObjcClass:[BaseModel class] NeedCache:NO];
}
- (void)userRegisterLoginId:(NSString *)loginId phone:(NSString *)phone password:(NSString *)password validateCode:(NSString *)validateCode nickName:(NSString *)nickName delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:loginId forKey:@"loginId"];
    [params setObject:phone forKey:@"phone"];
    [params setObject:password forKey:@"password"];
    [params setObject:validateCode forKey:@"validateCode"];
    [params setObject:nickName forKey:@"nickName"];
    [self POST:KUserRegisterInterface reqType:KUserRegisterRequest delegate:delegate parameters:params ObjcClass:[UserModel class] NeedCache:NO];
}
- (void)userLoginWithUserName:(NSString *)username password:(NSString *)password  delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [self POST:KUserLoginInterface reqType:KUserLoginRequest delegate:delegate parameters:params ObjcClass:[UserModel class] NeedCache:NO];

}

- (void)userLoginWithWeChatOpenID:(NSString *)openID delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:openID forKey:@"openid"];
    [self POST:KUserLoginInterface reqType:KUserLoginRequest delegate:delegate parameters:params ObjcClass:[UserModel class] NeedCache:NO];
}

- (void)userLoginWithQQID:(NSString *)qq delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:qq forKey:@"qq"];
    [self POST:KUserLoginInterface reqType:KUserLoginRequest delegate:delegate parameters:params ObjcClass:[UserModel class] NeedCache:NO];
}

- (void)userLoginWithWeiBo:(NSString *)blogId delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:blogId forKey:@"blogId"];
    [self POST:KUserLoginInterface reqType:KUserLoginRequest delegate:delegate parameters:params ObjcClass:[UserModel class] NeedCache:NO];
}

- (void)userResetPassword:(NSString *)phone password:(NSString *)password validateCode:(NSString *)validateCode delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:password forKey:@"password"];
    [params setObject:validateCode forKey:@"validateCode"];
    [self POST:KUserResetPasswordInterface reqType:KUserResetPasswordRequest delegate:delegate parameters:params ObjcClass:[UserModel class] NeedCache:NO];
}
- (void)userResetPhone:(NSString *)oldPhone validateCode1:(NSString *)validateCode1 newPhone:(NSString *)newPhone validateCode2:(NSString *)validateCode2 delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:oldPhone forKey:@"phone2"];
    [params setObject:validateCode1 forKey:@"validateCode2"];
    [params setObject:newPhone forKey:@"phone"];
    [params setObject:validateCode2 forKey:@"validateCode"];
    [self POST:KUserResetPhoneInterface reqType:KUserResetPhoneRequest delegate:delegate parameters:params ObjcClass:[UserModel class] NeedCache:NO];
}
- (void)updateUserInfoMyId:(NSString *)myId nickName:(NSString *)nickName headImgUrl:(NSString *)headImgUrl email:(NSString *)email delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (myId.length > 0) {
        [params setObject:myId forKey:@"myId"];
    }
    if (nickName.length > 0) {
        [params setObject:nickName forKey:@"nickName"];
    }
    if (headImgUrl.length > 0) {
        [params setObject:headImgUrl forKey:@"headImgUrl"];
    }
    if (email.length > 0) {
        [params setObject:email forKey:@"email"];
    }
    [self POST:KUserUpdateInfoInterface reqType:KUserUpdateInfoRequest delegate:delegate parameters:params ObjcClass:[UserModel class] NeedCache:NO];
}
- (void)userRealNameValidationIdCard:(NSString *)realName idCard:(NSString *)idCard idCardImg1:(NSString *)idCardImg1 idCardImg2:(NSString *)idCardImg2 idCardImg3:(NSString *)idCardImg3 idCardImg4:(NSString *)idCardImg4 delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:realName forKey:@"realName"];
    [params setObject:idCard forKey:@"idCard"];
    [params setObject:idCardImg1 forKey:@"idCardImg1"];
    [params setObject:idCardImg2 forKey:@"idCardImg2"];
    [params setObject:idCardImg3 forKey:@"idCardImg3"];
    [params setObject:idCardImg4 forKey:@"idCardImg4"];
    [self POST:KUserValidationIdCardInterface reqType:KUserValidationIdCardRequest delegate:delegate parameters:params ObjcClass:[UserModel class] NeedCache:NO];
}

- (void)userValidationCompany:(NSString *)companyName deptName:(NSString *)deptName workCardUrl:(NSString *)workCardUrl delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:companyName forKey:@"companyName"];
    [params setObject:deptName forKey:@"deptName"];
    [params setObject:workCardUrl forKey:@"workCardUrl"];
    [self POST:KUserValidationCompanyInterface reqType:KUserValidationCompanyRequest delegate:delegate parameters:params ObjcClass:[BaseModel class] NeedCache:NO];
}

- (void)userFeedBack:(NSString *)content delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:content forKey:@"content"];
    [self POST:KUserFeedBackInterface reqType:KUserFeedBackRequest delegate:delegate parameters:params ObjcClass:[BaseModel class] NeedCache:NO];
}

- (void)getBannerWithCityID:(NSString *)city delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (city.length > 0) {
        [params setObject:city forKey:@"cityId"];
    }
    [self POST:KBannerInterface reqType:KBannerRequest delegate:delegate parameters:params ObjcClass:[BannerListModel class] NeedCache:NO];
}

- (void)getNewList:(NewListType)listType lastId:(NSString *)lastId pageSize:(int)pageSize delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@((int)listType) forKey:@"type"];
    if (lastId.length > 0) {
        [params setObject:lastId forKey:@"lastId"];
    }
    [params setObject:@(pageSize) forKey:@"pageSize"];
    NSString *type = listType == NewListTypePopularInformation ? KGetNewsListPopInfoRequest : KGetNewsListSysNotiRequest;
    [self POST:KGetNewsListInterface reqType:type delegate:delegate parameters:params ObjcClass:[NewListModel class] NeedCache:NO];

}

- (void)getNewDetail:(NSString *)newsID delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:newsID forKey:@"newsId"];
    [self POST:KGetNewsDetailInterface reqType:KGetNewsDetailRequest delegate:delegate parameters:params ObjcClass:[NewDetailContenModel class] NeedCache:NO];
    
}

- (void)getCommentQuestionList:(NSString *)lastID pageSize:(int)pageSize delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (lastID.length > 0) {
        [params setObject:lastID forKey:@"lastId"];
    }
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [self POST:KGetCommentQuestionListInterface reqType:KGetCommentQuestionListRequest delegate:delegate parameters:params ObjcClass:[CommentQuestionListModel class] NeedCache:NO];
}

- (void)getCommentQuestionDetail:(NSString *)faqId delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:faqId forKey:@"faqId"];
    [self POST:KGetCommentQuestionDetailInterface reqType:KGetCommentQuestionDetailRequest delegate:delegate parameters:params ObjcClass:[CommentQuestionDetail class] NeedCache:NO];

}

- (void)getMessageCount:(int)status delegate:(id)delegate{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(status) forKey:@"status"];
    [self POST:KGetMessageCountInterface reqType:KGetMessageCountRequest delegate:delegate parameters:params ObjcClass:[ZRSWMessageCountModel class] NeedCache:NO];
}

- (void)getBillList:(int)pageSize pageNum:(int)pageNum delegate:(id)delegate{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(pageNum) forKey:@"pageNum"];
    [self POST:KGetBillListInterface reqType:KGetBillListRequest delegate:delegate parameters:params ObjcClass:[ZRSWBillListModel class] NeedCache:NO];
}

- (void)getRemindList:(int)pageSize pageNum:(int)pageNum delegate:(id)delegate{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(pageNum) forKey:@"pageNum"];
    [self POST:KGetRemindListInterface reqType:KGetRemindListRequest delegate:delegate parameters:params ObjcClass:[ZRSWRemindListModel class] NeedCache:NO];
}

- (void)updateMsgStatus:(NSString *)msgIds status:(int)status delegate:(id)delegate{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:msgIds forKey:@"msgIds"];
    [params setObject:@(status) forKey:@"status"];
    [self POST:KUpdateMsgStatusInterface reqType:KUpdateMsgStatusRequest delegate:delegate parameters:params ObjcClass:[BaseModel class] NeedCache:NO];
}


- (void)logOutWithDelegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserModel *model = [UserModel getCurrentModel];
    if (model.data.phone.length > 0) {
        [params setObject:model.data.phone forKey:@"phone"];
    }
    else {
        [params setObject:@"18600886745" forKey:@"phone"];

    }
    [self POST:KUserLogOutInterface reqType:KUserLogOutRequest delegate:delegate parameters:params ObjcClass:[BaseModel class] NeedCache:NO];

}































































@end
