
#pragma mark - 图片验证码类型

typedef enum : NSUInteger {
    ImageCodeTypeRegister, // 注册
    ImageCodeTypePwd, // 忘记密码
    ImageCodeTypeResetPhone // 绑定新手机
} ImageCodeType;

#pragma mark - 公告/咨询列表

typedef enum : NSUInteger {
    NewListTypePopularInformation = 0, // 热门资讯
    NewListTypeSystemNotification = 1 // 系统公告
    
} NewListType;
