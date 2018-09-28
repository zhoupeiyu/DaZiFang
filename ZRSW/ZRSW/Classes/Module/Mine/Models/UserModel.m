//
//  UserModel.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/12.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "UserModel.h"

#define KCityNameKey                @"KCityNameKey"
#define KCityIDKey                  @"KCityIDKey"

#define KUserModelKey               @"KUserModelKey"

@implementation ImageCode

@end

@implementation GetUserImageCodeModel

@end

@implementation UserInfoModel


@end

@implementation UserAuthNameAudit

@end

@implementation UserAuthCompanyAudit

@end

@implementation UserModel
SYNTHESIZE_SINGLETON_ARC(UserModel);
+ (void)updateUserModel:(UserModel *)model {
    NSDictionary *userDic = [model yy_modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:KUserModelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (UserModel *)getCurrentModel {
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:KUserModelKey];
    UserModel *model = [UserModel yy_modelWithJSON:userDic];
    return model;
}
+ (void)removeUserData {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUserModelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)hasLogin {
    UserModel *model = [self getCurrentModel];
    return model.data.hasLogin;
}
@end

@implementation CityDetailModel

@end

@implementation CityListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [CityDetailModel class],
             };
}

- (void)setData:(NSArray *)data {
    _data = data;
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    for (CityDetailModel *cityModel in data) {
        if (cityModel.name.length > 0 && cityModel.id.length > 0) {
            [titles addObject:cityModel.name];
            [ids addObject:cityModel.id];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:titles forKey:KCityNameKey];
    [[NSUserDefaults standardUserDefaults] setValue:ids forKey:KCityIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray <NSString *> *)getCityNames {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KCityNameKey];
}
+ (NSArray <NSString *> *)getCityIds {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KCityIDKey];
}

@end


@implementation BannerModel

@end

@implementation BannerListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [BannerModel class],
             };
}

@end

@implementation NewDetailModel

@end

@implementation NewListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [NewDetailModel class],
             };
}

@end


@implementation NewDetailContenModel

@end

@implementation NewDetailContensModel

@end


@implementation CommentQuestionModel

@end
@implementation CommentQuestionListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [CommentQuestionModel class],
             };
}

@end

@implementation CommentQuestionDetailContentModel

@end


@implementation  CommentQuestionDetail

@end

@implementation UploadImageDetailModel

@end

@implementation UploadImageModel

@end


























