
#pragma mark - 图片验证码类型

typedef enum : NSUInteger {
    ImageCodeTypeRegister, // 注册
    ImageCodeTypePwd, // 忘记密码
    ImageCodeTypeResetPhone, // 绑定新手机
    ImageCodeTypeResetPhone2 // 旧手机
} ImageCodeType;

#pragma mark - 公告/咨询列表

typedef enum : NSUInteger {
    NewListTypePopularInformation = 0, // 热门资讯
    NewListTypeSystemNotification = 1 // 系统公告
    
} NewListType;

#pragma mark - 公告/咨询/常见问题详情类型

typedef enum : NSUInteger {
    DetailsTypePopularInformation = 0, // 热门资讯
    DetailsTypeSystemNotification = 1, // 系统公告
    DetailsTypeCommentQuestion = 2 //常见问题
} DetailsType;
