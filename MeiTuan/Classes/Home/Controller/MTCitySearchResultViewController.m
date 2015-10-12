//
//  MTCitySearchResultViewController.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/10.
//  Copyright © 2015年 金顺度. All rights reserved.
//  显示城市搜索结果

#import "MTCitySearchResultViewController.h"
#import "MTCity.h"
#import "MTConst.h"
#import "MTMetaTool.h"

@interface MTCitySearchResultViewController ()
@property (nonatomic,strong)NSArray *resultCities;
@end

@implementation MTCitySearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setSearchText:(NSString *)searchText {
    _searchText = [searchText copy];
    searchText = searchText.lowercaseString;//转为小写,搜索时直接比较小写==>忽略大小写
//    self.resultCities = [NSMutableArray array];
    //根据关键字搜索想要的城市数据
    //1.遍历
//    for (MTCity *city in self.cities) {
//        if ([city.name containsString:searchText] || [city.pinYin containsString:searchText] || [city.pinYinHead containsString:searchText]) {
//            [self.resultCities addObject:city];
//        }
//    }
    //2.谓词：能根据一定的条件在一个数组中过滤出想要的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or  pinYin contains %@ or pinYinHead contains %@",searchText,searchText,searchText];//条件
    self.resultCities = [[MTMetaTool cities] filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultCities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    MTCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"共有%lu个搜索结果",self.resultCities.count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MTCity *city = self.resultCities[indexPath.row];
    //发出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:MTCityDidChangedNotification object:nil userInfo:@{MTSelectedCityName : city.name}];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
