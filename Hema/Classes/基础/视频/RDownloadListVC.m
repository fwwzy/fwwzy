//
//  RDownloadListVC.m
//  Hema
//
//  Created by geyang on 15/11/3.
//  Copyright © 2015年 Hemaapp. All rights reserved.
//

#import "RDownloadListVC.h"
#import "HSDownloadManager.h"
#import "ROneVideoPlayVC.h"

@interface RDownloadListVC ()
@property(nonatomic,strong)NSMutableArray *listArr;
@end

@implementation RDownloadListVC

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"视频下载"];
    [SystemFunction setTableSeparatorInset:self.mytable left:10];
    [self.navigationItem setRightItemWithTarget:self action:@selector(rightbtnPressed:) image:@"R清空.png"];
    [self forbidPullRefresh];
}
-(void)loadData
{
    NSMutableDictionary *myDic1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"视频一",@"name",@"http://www.hm5m.com/download/1.mp4",@"url", nil];
    NSMutableDictionary *myDic2 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"视频二",@"name",@"http://www.hm5m.com/download/2.mp4",@"url", nil];
    NSMutableDictionary *myDic3 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"视频三",@"name",@"http://www.hm5m.com/download/3.mp4",@"url", nil];
    _listArr = [[NSMutableArray alloc]initWithObjects:myDic1,myDic2,myDic3,nil];
}
#pragma mark- 自定义
#pragma mark 事件
-(void)rightbtnPressed:(id)sender
{
    [[HSDownloadManager sharedInstance] deleteAllFile];
    
    for (int i = 0; i<_listArr.count; i++)
    {
        UITableViewCell *cell = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        HemaButton *rightBtn = (HemaButton*)[cell viewWithTag:13];
        [rightBtn setTitle:[self getTitleWithDownloadState:DownloadStateSuspended] forState:UIControlStateNormal];
    }
    [self.mytable reloadData];
}
//下载或者播放
-(void)downPressed:(HemaButton*)sender
{
    UITableViewCell *cell = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.btnRow inSection:0]];
    NSMutableDictionary *temDic = [_listArr objectAtIndex:sender.btnRow];
    
    UIProgressView *progressView = (UIProgressView*)[cell viewWithTag:11];
    UILabel *labProgress = (UILabel*)[cell viewWithTag:12];
    HemaButton *rightBtn = (HemaButton*)[cell viewWithTag:13];
    
    if (1 == [[HSDownloadManager sharedInstance] progress:[temDic objectForKey:@"url"]])
    {
        ROneVideoPlayVC *myVC = [[ROneVideoPlayVC alloc]init];
        myVC.urlStr = [[HSDownloadManager sharedInstance] getFilePath:[temDic objectForKey:@"url"]];
        myVC.isLocal = YES;
        [self.navigationController pushViewController:myVC animated:YES];
    }else
    {
        [self download:[temDic objectForKey:@"url"] progressLabel:labProgress progressView:progressView button:rightBtn];
    }
}
//删除
-(void)deletePressed:(HemaButton*)sender
{
    UITableViewCell *cell = (UITableViewCell *)[self.mytable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.btnRow inSection:0]];
    NSMutableDictionary *temDic = [_listArr objectAtIndex:sender.btnRow];
    
    [[HSDownloadManager sharedInstance] deleteFile:[temDic objectForKey:@"url"]];
    HemaButton *rightBtn = (HemaButton*)[cell viewWithTag:13];
    [rightBtn setTitle:[self getTitleWithDownloadState:DownloadStateSuspended] forState:UIControlStateNormal];
    
    [self.mytable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sender.btnRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark 方法
//按钮状态
- (NSString *)getTitleWithDownloadState:(DownloadState)state
{
    switch (state)
    {
        case DownloadStateStart:
            return @"暂停";
        case DownloadStateSuspended:
        case DownloadStateFailed:
            return @"开始";
        case DownloadStateCompleted:
            return @"播放";
        default:
            break;
    }
}
//开启任务下载资源
- (void)download:(NSString *)url progressLabel:(UILabel *)progressLabel progressView:(UIProgressView *)progressView button:(HemaButton *)button
{
    [[HSDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
            progressView.progress = progress;
        });
    }state:^(DownloadState state)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setTitle:[self getTitleWithDownloadState:state] forState:UIControlStateNormal];
        });
    }];
}
#pragma mark- TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"all";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = BB_White_Color;
        
        //左侧
        UILabel *labLeft = [[UILabel alloc]init];
        labLeft.backgroundColor = [UIColor clearColor];
        labLeft.textAlignment = NSTextAlignmentLeft;
        labLeft.font = [UIFont systemFontOfSize:15];
        labLeft.tag = 10;
        labLeft.frame = CGRectMake(10, 10, 100, 20);
        labLeft.textColor = BB_Blake_Color;
        [cell.contentView addSubview:labLeft];
        
        //进度条
        UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        [progressView setFrame:CGRectMake(10, 39, 100, 2)];
        progressView.progressTintColor = BB_Blue_Color;
        progressView.trackTintColor = BB_White_Color;
        progressView.tag = 11;
        [cell.contentView addSubview:progressView];
        
        //进度
        UILabel *labProgress = [[UILabel alloc]init];
        labProgress.backgroundColor = [UIColor clearColor];
        labProgress.textAlignment = NSTextAlignmentLeft;
        labProgress.font = [UIFont systemFontOfSize:12];
        labProgress.tag = 12;
        labProgress.frame = CGRectMake(115, 30, 80, 20);
        labProgress.textColor = BB_Blake_Color;
        [cell.contentView addSubview:labProgress];
        
        //右侧下载按钮
        HemaButton *rightBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setFrame:CGRectMake(UI_View_Width-120, 15, 50, 25)];
        [HemaFunction addbordertoView:rightBtn radius:12.5 width:1.0 color:BB_Orange_Color];
        [rightBtn setTitleColor:BB_Orange_Color forState:UIControlStateNormal];
        [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [rightBtn setTitle:[self getTitleWithDownloadState:DownloadStateSuspended] forState:UIControlStateNormal];
        rightBtn.tag = 13;
        [cell.contentView addSubview:rightBtn];
        
        //右侧删除按钮
        HemaButton *deleteBtn = [HemaButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setFrame:CGRectMake(UI_View_Width-60, 15, 50, 25)];
        [HemaFunction addbordertoView:deleteBtn radius:12.5 width:1.0 color:BB_Gray_Color];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:BB_Gray_Color forState:UIControlStateNormal];
        [deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        deleteBtn.tag = 14;
        [cell.contentView addSubview:deleteBtn];
    }
    NSMutableDictionary *temDic = [_listArr objectAtIndex:indexPath.row];
    
    UILabel *labLeft = (UILabel*)[cell viewWithTag:10];
    labLeft.text = [temDic objectForKey:@"name"];
    
    UIProgressView *progressView = (UIProgressView*)[cell viewWithTag:11];
    progressView.progress = [[HSDownloadManager sharedInstance] progress:[temDic objectForKey:@"url"]];
    
    UILabel *labProgress = (UILabel*)[cell viewWithTag:12];
    labProgress.text = [NSString stringWithFormat:@"%.f%%", [[HSDownloadManager sharedInstance] progress:[temDic objectForKey:@"url"]] * 100];
    
    HemaButton *rightBtn = (HemaButton*)[cell viewWithTag:13];
    rightBtn.btnRow = indexPath.row;
    [rightBtn addTarget:self action:@selector(downPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[HSDownloadManager sharedInstance] progress:[temDic objectForKey:@"url"]] == 1)
    {
        [rightBtn setTitle:[self getTitleWithDownloadState:DownloadStateCompleted] forState:UIControlStateNormal];
    }
    
    HemaButton *deleteBtn =(HemaButton*)[cell viewWithTag:14];
    deleteBtn.btnRow = indexPath.row;
    [deleteBtn addTarget:self action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
#pragma mark- TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    
}
@end
