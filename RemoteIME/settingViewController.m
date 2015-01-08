//
//  settingViewController.m
//  RemoteIME
//
//  Created by APPLE28 on 15-1-8.
//  Copyright (c) 2015年 none. All rights reserved.
//

#import "settingViewController.h"

@interface settingViewController ()

@end

@implementation settingViewController
@synthesize buttonTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    buttonTable.delegate=self;
    buttonTable.dataSource=self;
    //buttonTable.style = UITableViewStyleGrouped;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    else {
        while ([cell.contentView.subviews lastObject ]!=nil) {
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    //    获取当前行信息值
    NSUInteger row = [indexPath row];
    //    填充行的详细内容
    //cell.detailTextLabel.text = @"详细内容";
    //    把数组中的值赋给单元格显示出来
    if(row == 0){
        cell.textLabel.text=@"关于";//[self.listData objectAtIndex:row];
    }else{
        cell.textLabel.text=@"使用教程";
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    //    cell.textLabel.backgroundColor= [UIColor greenColor];
    
    //    表视图单元提供的UILabel属性，设置字体大小
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    //    tableView.editing=YES;
    /*
     cell.textLabel.backgroundColor = [UIColor clearColor];
     UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
     backgroundView.backgroundColor = [UIColor greenColor];
     cell.backgroundView=backgroundView;
     */
    //    设置单元格UILabel属性背景颜色
    //cell.textLabel.backgroundColor=[UIColor clearColor];
    //    正常情况下现实的图片
    //UIImage *image = [UIImage imageNamed:@"2.png"];
    //cell.imageView.image=image;
    
    //    被选中后高亮显示的照片
    //UIImage *highLightImage = [UIImage imageNamed:@"1.png"];
    //cell.imageView.highlightedImage = highLightImage;
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row ==0 ){
        UIViewController *transview = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"instruct"];
        [self.navigationController pushViewController:transview animated:YES];
    }else{
        SplashViewController *splash = [[SplashViewController alloc] init];
        [self presentViewController:splash animated:YES completion:nil];

    }
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60.0f;
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
    [title setText:@"系统帮助"];
    [title setFont:[UIFont boldSystemFontOfSize:20]];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextColor:[UIColor blackColor]];
    [title setTextAlignment:NSTextAlignmentLeft];
    [container addSubview:title];
    return container;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    
    return 40.0;
    
}
@end
