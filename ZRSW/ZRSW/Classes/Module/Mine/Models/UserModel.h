//
//  UserModel.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/12.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseModel.h"
#import "BaseUploadModel.h"
#import "NSString+JKHash.h"

#define DefaultNickName         @"小明"

#pragma mark -  图片验证码

@interface ImageCode : NSObject

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *code;

@end

@interface GetUserImageCodeModel : BaseModel

@property (nonatomic, strong) ImageCode *data;

@end

#pragma mark - 用户注册

@interface UserAuthCompanyAudit  : NSObject
//审核编号
@property (nonatomic, strong) NSString *id;
//认证类型：1-实名审核 2-企业认证
@property (nonatomic, strong) NSNumber *auditType;
// 审核结果：1-通过 2-拒绝
@property (nonatomic, strong) NSNumber *auditRes;
//审核结果说明
@property (nonatomic, strong) NSString *auditRemark;
//公司名称
@property (nonatomic, strong) NSString *data1;
//所属部门
@property (nonatomic, strong) NSString *data2;
// 职务名称
@property (nonatomic, strong) NSString *data3;
//工作证图片URL
@property (nonatomic, strong) NSString *data4;

@end

@interface UserAuthNameAudit  : NSObject
//审核编号
@property (nonatomic, strong) NSString *id;
//认证类型：1-实名审核 2-企业认证
@property (nonatomic, strong) NSNumber *auditType;
//审核结果：1-通过 2-拒绝
@property (nonatomic, strong) NSNumber *auditRes;
//审核结果说明
@property (nonatomic, strong) NSString *auditRemark;
//身份证正面照URL
@property (nonatomic, strong) NSString *data1;
//身份证反面照URL
@property (nonatomic, strong) NSString *data2;
//手持身份证正面照URL
@property (nonatomic, strong) NSString *data3;
//手持身份证反面照URL
@property (nonatomic, strong) NSString *data4;

@end


@interface UserInfoModel : BaseModel
// 用户id
@property (nonatomic, strong) NSString *id;
//登陆账号
@property (nonatomic, strong) NSString *loginId;
//用户昵称
@property (nonatomic, strong) NSString *nickName;
//手机号
@property (nonatomic, strong) NSString *phone;
//用户头像URL
@property (nonatomic, strong) NSString *headImgUrl;
//用户掮客号
@property (nonatomic, strong) NSString *myId;
//用户性别：1：男；2：女；
@property (nonatomic, strong) NSNumber *sex;
// 用户简介
@property (nonatomic, strong) NSString *profile;
//真实姓名
@property (nonatomic, strong) NSString *realName;
//身份证号码
@property (nonatomic, strong) NSString *idCard;
//身份证正面照URL
@property (nonatomic, strong) NSString *idCardImg1;
//身份证反面照URL
@property (nonatomic, strong) NSString *idCardImg2;
//手持身份证正面照URL
@property (nonatomic, strong) NSString *idCardImg3;
//手持身份证反面照URL
@property (nonatomic, strong) NSString *idCardImg4;
//公司名称
@property (nonatomic, strong) NSString *companyName;
//所属部门
@property (nonatomic, strong) NSString *deptName;
//职务名称
@property (nonatomic, strong) NSString *roleName;
//工作证图片URL
@property (nonatomic, strong) NSString *workCardUrl;
// 电子邮箱
@property (nonatomic, strong) NSString *email;
//所在省份
@property (nonatomic, strong) NSString *province;
//所在城市
@property (nonatomic, strong) NSString *city;
//详细地址
@property (nonatomic, strong) NSString *detailAddress;
//实名认证状态：-1：未认证；0:资料已提交待审核；1：已认证；2认证失败
@property (nonatomic, strong) NSString *authName;
//企业认证状态：-1：未认证；0:资料已提交待审核；1：已认证；2认证失败
@property (nonatomic, strong) NSString *authCompany;
@property (nonatomic, strong) UserAuthNameAudit *authNameAudit;
@property (nonatomic, strong) UserAuthCompanyAudit *authCompanyAudit;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) BOOL hasLogin;
//环信id,其值为用户id，环信密码默认为123456，昵称为用户昵称或手机号
@property (nonatomic, strong) NSString *huanXinName;
//刷脸认证faceTokens
@property (nonatomic, strong) NSString *faceTokens;
//是否开启刷脸认证
@property (nonatomic, assign) int faceLogin;
//我的邀请码
@property (nonatomic, strong) NSString *myInvitationCode;

@end

@interface UserModel : BaseModel

+ (UserModel *)sharedInstance;
@property (nonatomic, strong) UserInfoModel *data;

+ (BOOL)hasLogin;

+ (void)updateUserModel:(UserModel *)model;
+ (UserModel *)getCurrentModel;
+ (void)removeUserData;

@end

#pragma mark - 城市列表

@interface CityDetailModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;

@end

@interface CityListModel : BaseModel
@property (nonatomic, strong) NSArray *data;

+ (NSArray <NSString *> *)getCityNames;
+ (NSArray <NSString *> *)getCityIds;
@end


#pragma mark - banner

@interface BannerModel : NSObject
//banner id
@property (nonatomic, strong) NSString *id;
//标题
@property (nonatomic, strong) NSString *title;
//banner图片URL
@property (nonatomic, strong) NSString *imgUrl;
// banner点击跳转地址，为空时点击不跳转
@property (nonatomic, strong) NSString *href;

@end

@interface BannerListModel : BaseModel

@property (nonatomic, strong) NSArray *data;

@end

#pragma mark - 热门资讯 / 系统公告

@interface NewDetailModel : NSObject

//id标识
@property (nonatomic, strong) NSString *id;
//标题
@property (nonatomic, strong) NSString *title;
//摘要
@property (nonatomic, strong) NSString *roundup;
//封面图片URL
@property (nonatomic, strong) NSString *imgUrl;
//发布时间,格式：yyyy/MM/dd HH:mm:ss "2018/09/09 09:09:09",
@property (nonatomic, strong) NSString *updateTime;
// 类型：1=热门资讯-活动，2=热门资讯-资讯；4=系统公告
@property (nonatomic, strong) NSString *newsType;
//点击量
@property (nonatomic, strong) NSString *readers;
//来源媒体
@property (nonatomic, strong) NSString *sourceName;
//原文链接地址
@property (nonatomic, strong) NSString *sourceUrl;


@end

@interface NewListModel : BaseModel

@property (nonatomic, strong) NSArray *data;
@end

#pragma mark - 资讯详情

@interface NewDetailContensModel : NSObject

//id标识
@property (nonatomic, strong) NSString *id;
//标题
@property (nonatomic, strong) NSString *title;
//摘要
@property (nonatomic, strong) NSString *roundup;
//关键字
@property (nonatomic, strong) NSString *keyword;
//封面图片URL
@property (nonatomic, strong) NSString *imgUrl;
//内容：html格式
@property (nonatomic, strong) NSString *content;
//发布时间
@property (nonatomic, strong) NSString *updateTime;
//类型：1=热门资讯-活动，2=热门资讯-资讯；4=系统公告
@property (nonatomic, strong) NSString *newsType;
//点击量
@property (nonatomic, strong) NSString *readers;
//来源媒体
@property (nonatomic, strong) NSString *sourceName;
//原文链接地址
@property (nonatomic, strong) NSString *sourceUrl;

@property (nonatomic, strong) NSString *contentStr;

+(NSString*)encodeString:(NSString*)unencodedString;

@end
@interface NewDetailContenModel : BaseModel
@property (nonatomic, strong) NewDetailContensModel *data;
@end

#pragma mark - 问题列表

@interface CommentQuestionModel : NSObject
//id标识
@property (nonatomic, strong) NSString *id;
//标题
@property (nonatomic, strong) NSString *title;
//内容
@property (nonatomic, strong) NSString *faqBody;
//发布时间,格式：yyyy/MM/dd HH:mm:ss
@property (nonatomic, strong) NSString *updateTime;
//阅读量
@property (nonatomic, strong) NSString *readers;


@end
@interface CommentQuestionListModel : BaseModel

@property (nonatomic, strong) NSArray *data;
@end

#pragma mark - 问题详情
@interface CommentQuestionDetailContentModel : NSObject
//id标识
@property (nonatomic, strong) NSString *id;
//标题
@property (nonatomic, strong) NSString *title;
//内容
@property (nonatomic, strong) NSString *faqBody;
//发布时间,格式：yyyy/MM/dd HH:mm:ss
@property (nonatomic, strong) NSString *updateTime;
//封面图片URL
@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) NSString *faqBodyStr;
//阅读量
@property (nonatomic, strong) NSString *readers;

@end

@interface CommentQuestionDetail : BaseModel

@property (nonatomic, strong) CommentQuestionDetailContentModel *data;

@end


#pragma mark - 图片

@interface UploadImageDetailModel : NSObject

@property (nonatomic, strong) NSString *fileUrl;

@end
@interface UploadImageModel : BaseUploadModel
@property (nonatomic, strong) UploadImageDetailModel *data;

@end


@interface SignStatesModel : BaseModel
// 是否已签到：true=已签到，false=未签到
@property (nonatomic, strong) NSNumber *signIn;
// 是否已签退：true=已签退，false=未签退
@property (nonatomic, strong) NSNumber *signOut;
@end

@interface SignModel : BaseModel
@property (nonatomic, strong) SignStatesModel *data;
@end









































