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
    NSDictionary *userDic = nil;
    UserModel *userModel = [self getCurrentModel];
    if (userModel) {
        if (model.data.id.length > 0) {
            userModel.data.id = model.data.id;
        }
        if (model.data.loginId.length > 0) {
            userModel.data.loginId = model.data.loginId;
        }
        if (model.data.nickName.length > 0) {
            userModel.data.nickName = model.data.nickName;
        }
        if (model.data.phone.length > 0) {
            userModel.data.phone = model.data.phone;
        }
        if (model.data.headImgUrl.length > 0) {
            userModel.data.headImgUrl = model.data.headImgUrl;
        }
        if (model.data.myId.length > 0) {
            userModel.data.myId = model.data.myId;
        }
        if (model.data.sex) {
            userModel.data.sex = model.data.sex;
        }
        if (model.data.profile.length > 0) {
            userModel.data.profile = model.data.profile;
        }
        if (model.data.realName.length > 0) {
            userModel.data.realName = model.data.realName;
        }
        if (model.data.idCard.length > 0) {
            userModel.data.idCard = model.data.idCard;
        }
        if (model.data.idCardImg1.length > 0) {
            userModel.data.idCardImg1 = model.data.idCardImg1;
        }
        if (model.data.idCardImg2.length > 0) {
            userModel.data.idCardImg2 = model.data.idCardImg2;
        }
        if (model.data.idCardImg3.length > 0) {
            userModel.data.idCardImg3 = model.data.idCardImg3;
        }
        if (model.data.idCardImg4.length > 0) {
            userModel.data.idCardImg4 = model.data.idCardImg4;
        }
        if (model.data.companyName.length > 0) {
            userModel.data.companyName = model.data.companyName;
        }
        if (model.data.deptName.length > 0) {
            userModel.data.deptName = model.data.deptName;
        }
        if (model.data.roleName.length > 0) {
            userModel.data.roleName = model.data.roleName;
        }
        if (model.data.workCardUrl.length > 0) {
            userModel.data.workCardUrl = model.data.workCardUrl;
        }
        if (model.data.email.length > 0) {
            userModel.data.email = model.data.email;
        }
        if (model.data.province.length > 0) {
            userModel.data.province = model.data.province;
        }
        if (model.data.city.length > 0) {
            userModel.data.city = model.data.city;
        }
        if (model.data.detailAddress.length > 0) {
            userModel.data.detailAddress = model.data.detailAddress;
        }
        if (model.data.authName.length > 0) {
            userModel.data.authName = model.data.authName;
        }
        if (model.data.authCompany.length > 0) {
            userModel.data.authCompany = model.data.authCompany;
        } //
        if (model.data.token.length > 0) {
            userModel.data.token = model.data.token;
            [BaseNetWorkService sharedInstance].loginToken = model.data.token;
        }
        if (model.data.huanXinName.length > 0) {
            userModel.data.huanXinName = model.data.huanXinName;
        }
        if (model.data.faceTokens.length > 0) {
            userModel.data.faceTokens = model.data.faceTokens;
        }
        if (model.data.myInvitationCode.length > 0) {
            userModel.data.myInvitationCode = model.data.myInvitationCode;
        }

        userModel.data.faceLogin = model.data.faceLogin;
        if (model.data.authNameAudit) {
            if (!userModel.data.authNameAudit) {
                UserAuthNameAudit *auth = [[UserAuthNameAudit alloc] init];
                userModel.data.authNameAudit = auth;
            }
            if (model.data.authNameAudit.id.length > 0) {
                userModel.data.authNameAudit.id = model.data.authNameAudit.id;
            }
            if (model.data.authNameAudit.auditType) {
                userModel.data.authNameAudit.auditType = model.data.authNameAudit.auditType;
            }
            if (model.data.authNameAudit.auditRes) {
                userModel.data.authNameAudit.auditRes = model.data.authNameAudit.auditRes;
            }
            if (model.data.authNameAudit.auditRemark.length > 0) {
                userModel.data.authNameAudit.auditRemark = model.data.authNameAudit.auditRemark;
            }
            if (model.data.authNameAudit.data1.length > 0) {
                userModel.data.authNameAudit.data1 = model.data.authNameAudit.data1;
            }
            if (model.data.authNameAudit.data2.length > 0) {
                userModel.data.authNameAudit.data2 = model.data.authNameAudit.data2;
            }
            if (model.data.authNameAudit.data3.length > 0) {
                userModel.data.authNameAudit.data3 = model.data.authNameAudit.data3;
            }
            if (model.data.authNameAudit.data4.length > 0) {
                userModel.data.authNameAudit.data4 = model.data.authNameAudit.data4;
            }
            userModel.data.hasLogin = model.data.hasLogin;
        }
        if (model.data.authCompanyAudit) {
            if (!userModel.data.authCompanyAudit) {
                UserAuthCompanyAudit *auth = [[UserAuthCompanyAudit alloc] init];
                userModel.data.authCompanyAudit = auth;
            }
            if (model.data.authCompanyAudit.id.length > 0) {
                userModel.data.authCompanyAudit.id = model.data.authCompanyAudit.id;
            }
            if (model.data.authCompanyAudit.auditType) {
                userModel.data.authCompanyAudit.auditType = model.data.authCompanyAudit.auditType;
            }
            if (model.data.authCompanyAudit.auditRes) {
                userModel.data.authCompanyAudit.auditRes = model.data.authCompanyAudit.auditRes;
            }
            if (model.data.authCompanyAudit.auditRemark.length > 0) {
                userModel.data.authCompanyAudit.auditRemark = model.data.authCompanyAudit.auditRemark;
            }
            if (model.data.authCompanyAudit.data1.length > 0) {
                userModel.data.authCompanyAudit.data1 = model.data.authCompanyAudit.data1;
            }
            if (model.data.authCompanyAudit.data2.length > 0) {
                userModel.data.authCompanyAudit.data2 = model.data.authCompanyAudit.data2;
            }
            if (model.data.authCompanyAudit.data3.length > 0) {
                userModel.data.authCompanyAudit.data3 = model.data.authCompanyAudit.data3;
            }
            if (model.data.authCompanyAudit.data4.length > 0) {
                userModel.data.authCompanyAudit.data4 = model.data.authCompanyAudit.data4;
            }
        }
        userDic = [userModel yy_modelToJSONObject];
    }
    else {
        userDic = [model yy_modelToJSONObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:KUserModelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //注册极光
    if (model.data.id) {
        NSString *alias = [model.data.id jk_md5String];
        [JPUSHService setAlias:[model.data.id jk_md5String] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        LLog(@"===iResCode=%ld====iAlias=%@===seq=%ld",iResCode,iAlias,seq);
        } seq:1];
    }
}
+ (UserModel *)getCurrentModel {
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:KUserModelKey];
    UserModel *model = [UserModel yy_modelWithJSON:userDic];
    return model;
}
+ (void)removeUserData {
    [JPUSHService deleteAlias:nil seq:1];
    [BaseNetWorkService removeUserToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUserModelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)hasLogin {
    UserModel *model = [self getCurrentModel];
    return model;
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

+(NSString*)encodeString:(NSString*)unencodedString{
    // CharactersToBeEscaped = @":/?&;=;aliyunzixun@xxx.com#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&;=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

- (void)setContent:(NSString *)content {
    _content = [NewDetailContensModel encodeString:content];
}
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

- (void)setFaqBody:(NSString *)faqBody {
   _faqBody = [NewDetailContensModel encodeString:faqBody];

}

@end


@implementation  CommentQuestionDetail

@end

@implementation UploadImageDetailModel

@end

@implementation UploadImageModel

@end


























