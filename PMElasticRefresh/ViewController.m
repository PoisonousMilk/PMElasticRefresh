//
//  ViewController.m
//  PMElasticRefresh
//
//  Created by Andy on 16/4/13.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import "ViewController.h"
#import "PMElasticRefresh.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
//@property (nonatomic, strong) PMElasticView *elasticView;
@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"PMElasticRefresh";
    self.dataArray = @[@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源",@"数据源"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"恢复" style:UIBarButtonItemStylePlain target:self action:@selector(restoreAction)];
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView pm_RefreshHeaderWithBlock:^{
       
        NSLog(@"refreshBlock");
    }];
    [self.view addSubview:self.mainTableView];
}

- (void)restoreAction {

    [self.mainTableView endRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
