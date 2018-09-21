//
//  UserService.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/12.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseNetWorkService.h"
#import "EnumType.h"
#import "ZRSWRemindListModel.h"

@interface UserService : BaseNetWorkService

/**
 获取图片验证码

 @param imageCodeType 类型
 @param delegate 代理
 */
- (void)getUserImageCode:(ImageCodeType)imageCodeType delegate:(id)delegate;


/**
 获取手机验证码

 @param imageCodeType 类型
 @param phone 手机号
 @param delegate 代理
 */
- (void)getUserPhoneCode:(ImageCodeType)imageCodeType phone:(NSString *)phone delegate:(id)delegate;


/**
 用户注册

 @param loginId 用户名
 @param phone 手机号
 @param password 密码
 @param validateCode 验证码
 @param nickName 昵称
 @param delegate 代理
 */
- (void)userRegisterLoginId:(NSString *)loginId phone:(NSString *)phone password:(NSString *)password validateCode:(NSString *)validateCode nickName:(NSString *)nickName delegate:(id)delegate;



/**
 用户账号密码登录

 @param username 用户名：手机号或用户帐户
 @param password 密码：当使用username登陆时必选
 @param delegate 代理
 */
- (void)userLoginWithUserName:(NSString *)username password:(NSString *)password  delegate:(id)delegate;


/**
 微信登录

 @param openID 微信openid；
 @param delegate 代理
 */
- (void)userLoginWithWeChatOpenID:(NSString *)openID delegate:(id)delegate;



/**
 QQ登录

 @param qq qq
 @param delegate 代理
 */
- (void)userLoginWithQQID:(NSString *)qq delegate:(id)delegate;


/**
 微博登录

 @param blogId 微博ID
 @param delegate 代理
 */
- (void)userLoginWithWeiBo:(NSString *)blogId delegate:(id)delegate;


/**
 重置密码

 @param phone 手机号
 @param password 密码
 @param validateCode 验证码
 @param delegate 代理
 */
- (void)userResetPassword:(NSString *)phone password:(NSString *)password validateCode:(NSString *)validateCode delegate:(id)delegate;


/**
 更换手机号

 @param oldPhone 旧手机号
 @param validateCode1 旧手机号对应的验证码
 @param newPhone 新手机号
 @param validateCode2 新手机号对应的验证码
 @param delegate 代理
 */
- (void)userResetPhone:(NSString *)oldPhone validateCode1:(NSString *)validateCode1 newPhone:(NSString *)newPhone validateCode2:(NSString *)validateCode2 delegate:(id)delegate;


/**
 更新用户信息

 @param myId 掮客号
 @param nickName 昵称
 @param headImgUrl 头像URL地址
 @param email 电子邮箱
 @param delegate 代理
 */
- (void)updateUserInfoMyId:(NSString *)myId nickName:(NSString *)nickName headImgUrl:(NSString *)headImgUrl email:(NSString *)email delegate:(id)delegate;


/**
  实名认证接口

 @param realName 用户真实姓名
 @param idCard 身份证号码
 @param idCardImg1 身份证正面照URL
 @param idCardImg2 身份证反面照URL
 @param idCardImg3 手持身份证正面照URL
 @param idCardImg4 手持身份证反面照URL
 @param delegate 代理
 */
- (void)userRealNameValidationIdCard:(NSString *)realName idCard:(NSString *)idCard idCardImg1:(NSString *)idCardImg1 idCardImg2:(NSString *)idCardImg2 idCardImg3:(NSString *)idCardImg3 idCardImg4:(NSString *)idCardImg4 delegate:(id)delegate;


/**
 企业认证

 @param companyName 公司名称
 @param deptName 所在部门
 @param workCardUrl 工牌照片URL
 @param delegate 代理
 */
- (void)userValidationCompany:(NSString *)companyName deptName:(NSString *)deptName workCardUrl:(NSString *)workCardUrl delegate:(id)delegate;


/**
 意见反馈

 @param content 内容
 @param delegate 代理
 */
- (void)userFeedBack:(NSString *)content delegate:(id)delegate;

#pragma mark - 首页列表


/**
 获取城市列表

 @param delegate 代理
 */
- (void)getCityListDelegate:(id)delegate;



/**
 获取banner

 @param city 城市ID 城市id：查询指定城市下的banner；默认为空，查询所有banner数据；
 @param delegate 代理
 */
- (void)getBannerWithCityID:(NSString *)city delegate:(id)delegate;


/**
 公告/资讯列表
 @param listType 类型 0=热门资讯；1=系统公告
 @param lastId 最后一次查询的最后一笔数据的id；
 @param pageSize 查询条数 默认为空查询最新数据 ，默认等于5
 @param delegate
 */
- (void)getNewList:(NewListType)listType lastId:(NSString *)lastId pageSize:(int)pageSize delegate:(id)delegate;


/**
 获得新闻详情

 @param newsID 新闻ID
 @param delegate 代理
 */
- (void)getNewDetail:(NSString *)newsID delegate:(id)delegate;



/**
 常见问题列表

 @param lastID 最后一个ID
 @param pageSize 查询条数 默认为空查询最新数据 ，默认等于5
 @param delegate 代理
 */
- (void)getCommentQuestionList:(NSString *)lastID pageSize:(int)pageSize delegate:(id)delegate;


/**
 问题详情

 @param lastID ID
 @param delegate 代理
 */
- (void)getCommentQuestionDetail:(NSString *)faqId delegate:(id)delegate;

/**
 问题详情

 @param username 用户名
 @param password 密码
 @param name ID 昵称
 @param delegate 代理
 */
- (void)getRemindList:(NSString *)username password:(NSString *)password name:(NSString *)name delegate:(id)delegate;


























































@end

