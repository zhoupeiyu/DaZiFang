//
//  ZRSWSelectTheCityController.m
//  ZRSW
//
//  Created by King on 2018/10/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWSelectTheCityController.h"
#import "OrderService.h"
#import "ZRSWSelectTheCityCell.h"
@interface ZRSWSelectTheCityController ()
@property (nonatomic, strong) NSMutableArray *dataListSource;
@end

@implementation ZRSWSelectTheCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataListSource = [NSMutableArray arrayWithCapacity:0];
    // Do any additional setup after loading the view.
}


- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = @"切换城市";
}

- (void)viewWillAppear:(BOOL)animated{
    self.dataListSource = [self sortObjectsAccordingToInitialWith:self.cityArray];
    [self.tableView reloadData];
}


// 按首字母分组排序数组
-(NSMutableArray *)sortObjectsAccordingToInitialWith:(NSArray *)arr {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];

    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    for (CityDetailModel *city in arr) {
        NSInteger sectionNumber = [collation sectionForObject:city collationStringSelector:@selector(name)];
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:city];
    }
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *cityArrayForSection = newSectionsArray[index];
        NSArray *sortedCityArrayForSection = [collation sortedArrayFromArray:cityArrayForSection collationStringSelector:@selector(name)];
        newSectionsArray[index] = sortedCityArrayForSection;
    }
    return newSectionsArray;
}

#pragma mark - tableView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *citySection = self.dataListSource[section];
    if (citySection.count != 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kUI_HeightS(30))];
        bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 250, kUI_HeightS(30))];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorFromRGB:0x474455];
        titleLabel.font = [UIFont systemFontOfSize:16];
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        NSString *key = [collation.sectionTitles objectAtIndex:section];
        titleLabel.text = key;
        [bgView addSubview:titleLabel];
        return bgView;;
    }else{
        return nil;
    }

}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
     UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    if (self.dataListSource.count >0 ) {
        return collation.sectionTitles;
    }else{
        return nil;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    tableView.sectionIndexColor = [UIColor colorFromRGB:0x474455];
    for (UIView *view in [tableView subviews]) {
        if ([view isKindOfClass:[NSClassFromString(@"UITableViewIndex") class]]){
            [view setValue:[UIFont systemFontOfSize:14] forKey:@"_font"];
        }
    }
   return self.dataListSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *citySection = self.dataListSource[section];
    return citySection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *citySection = self.dataListSource[indexPath.section];
    CityDetailModel *city = citySection[indexPath.row];
    ZRSWSelectTheCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZRSWSelectTheCityCell"];
    if (!cell) {
        cell = [[ZRSWSelectTheCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZRSWSelectTheCityCell"];
    }
    if (indexPath.row == 0) {
        cell.topLineHidden = YES;
    }
    cell.city = city;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_HeightS(45);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSArray *citySection = self.dataListSource[section];
    if (citySection.count != 0) {
        return kUI_HeightS(30);
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *citySection = self.dataListSource[indexPath.section];
    CityDetailModel *city = citySection[indexPath.row];
     [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCityNotification object:city];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    //点击索引，列表跳转到对应索引的行
    NSArray *citySection = self.dataListSource[index];
    if (citySection.count != 0) {
        [tableView
         scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
         atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return index;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
