//
//  ServiceInterface.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/12.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#ifndef ServiceInterface_h
#define ServiceInterface_h

// 图片验证码
#define KGetImageCodeInterface                          @"api/sms/drawImgValidateCode"

// 手机验证码
#define KGetPhoneCodeInterface                          @"api/sms/getValidateCode"

// 用户注册
#define KUserRegisterInterface                          @"api/user/register"

// 用户登录
#define KUserLoginInterface                             @"api/user/login"

// 重置密码
#define KUserResetPasswordInterface                     @"api/user/resetPwd"

// 更换手机号
#define KUserResetPhoneInterface                        @"user/resetPhone"

// 更新用户信息
#define KUserUpdateInfoInterface                        @"api/user/resetUserInfo"

// 实名认证
#define KUserValidationIdCardInterface                  @"api/user/validationIdCard"

// 公司认证
#define KUserValidationCompanyInterface                 @"api/user/validationCompany"

// 意见反馈
#define KUserFeedBackInterface                          @"api/user/feedBack"

// 城市列表
#define KCityListInterface                              @"api/index/citys"

// banner
#define KBannerInterface                                @"api/index/banners"

// 获取公告/ 资讯
#define KGetNewsListInterface                           @"api/index/news"

// 公告/资讯详情
#define KGetNewsDetailInterface                         @"api/index/newsInfo"

// 问题列表
#define KGetCommentQuestionListInterface                @"api/index/faqs"

// 问题详情
#define KGetCommentQuestionDetailInterface              @"api/index/faqInfo"



































#endif /* ServiceInterface_h */
