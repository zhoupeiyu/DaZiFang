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

// 退出登录
#define KUserLogOutInterface                            @"api/user/deleteUser"
// 重置密码
#define KUserResetPasswordInterface                     @"api/user/resetPwd"

// 更换手机号
#define KUserResetPhoneInterface                        @"api/user/resetPhone"

// 更新用户信息
#define KUserUpdateInfoInterface                        @"api/user/resetUserInfo"

// 实名认证
#define KUserValidationIdCardInterface                  @"api/user/validationIdCard"

// 公司认证
#define KUserValidationCompanyInterface                 @"api/user/validationCompany"

// 意见反馈
#define KUserFeedBackInterface                          @"api/user/feedBack"

// 上传图片
#define KUserUploadImageInterface                       @"api/user/uploadFile"
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

// 账单列表
#define KGetBillListInterface                @"api/order/recordList"


// 提醒列表
#define KGetRemindListInterface                         @"api/message/msgList"

// 更新阅读状态
#define KUpdateMsgStatusInterface                         @"api/message/updateMsgStatus"



// 贷款大类列表接口
#define KGetOrderMainTypeListInterface                  @"api/order/mainTypeList"

//贷款产品列表接口
#define KGetOrderLoanTypeListInterface                  @"api/order/loanTypeList"

// 贷款产品详情
#define KGetOrderLoanInfoInterface                      @"api/order/loanTypeInfo"

// 订单列表
#define KGetOrderListInterface                          @"api/order/orderList"






























#endif /* ServiceInterface_h */
