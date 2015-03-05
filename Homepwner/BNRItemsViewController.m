//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by 朱正晶 on 15-3-4.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

#define CELL_ID @"UITableViewCell"

@interface BNRItemsViewController()
@property (nonatomic, strong) NSMutableArray *bigArray;
@property (nonatomic, strong) NSMutableArray *leftArray;
@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }

    // 初始化数组
    self.bigArray = [NSMutableArray array];
    self.leftArray = [NSMutableArray array];

    for (BNRItem *item in [[BNRItemStore sharedStore] allItems]) {
        if (item.valueInDollars > 50) {
            [self.bigArray addObject:item];
        } else {
            [self.leftArray addObject:item];
        }
    }

    // 在最后的数组加上No more items!
    if ([self.leftArray count] > 0) {
        [self.leftArray addObject:@"No more items!"];
    } else {
        [self.bigArray addObject:@"No more items!"];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建cell的过程交由系统管理--告诉视图，如果对象池中没有UITableViewCell对象，应该初始化哪种类型的UITableViewCell对象
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_ID];
}

// 返回有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int section = 0;

    if (self.bigArray.count > 0) {
        section++;
    }
    
    if (self.leftArray.count > 0) {
        section++;
    }
    
    return section;
}

// 返回每一个section有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = 0;
    switch (section) {
        case 0:
            // 第一个，显示大于50美元的表格
            if ([self.bigArray count] == 0) {
                number = [self.leftArray count];
            } else {
                number = [self.bigArray count];
            }
            break;
        case 1:
            // 第二个，显示其余的表格
            number = [self.leftArray count];
            break;
        default:
            break;
    }
    return number;
}

// 返回每行的高度
// 有更加优雅的方法吗？
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexFlag1 = %d, %d", indexPath.section, indexPath.row);
    if (([self.bigArray count] == 0 && indexPath.row == [self.leftArray count] - 1) ||
        ([self.leftArray count] == 0 && indexPath.row == [self.bigArray count] - 1)) {
        return 44;
    }
    
    if (indexPath.section == 1 && indexPath.row == [self.leftArray count] - 1) {
        return 44;
    }
    
    NSLog(@"indexFlag2 = %d, %d", indexPath.section, indexPath.row);

    return 80;
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    switch (section) {
        case 0:
            if ([self.bigArray count] == 0) {
                title = @"其余";
            } else {
                title = @"大于50美元";
            }
            break;
        case 1:
            title = @"其余";
       default:
            break;
    }

    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int count;
    NSString *cellText;
    
    // 使用这种方法，必须调用registerClass注册
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            // 大于50美元
            count = [self.leftArray count];
            if (count == 0 && indexPath.row == [self.bigArray count] - 1) {
                cellText = self.bigArray[indexPath.row];
            } else if ([self.bigArray count] == 0){
                count = self.leftArray.count - 1;
                if (indexPath.row == count) {
                    cellText = self.leftArray[indexPath.row];
                } else {
                    cellText = [self.leftArray[indexPath.row] description];
                }
            }
            else {
                cellText = [self.bigArray[indexPath.row] description];
            }
            break;
        case 1:
            // 其余的
            count = self.leftArray.count - 1;
            if (indexPath.row == count) {
                cellText = self.leftArray[indexPath.row];
            } else {
                cellText = [self.leftArray[indexPath.row] description];
            }
            break;
        default:
            cellText = @"Unknown cell text";
            break;
    }
    cell.textLabel.text = cellText;
    return cell;
}

@end
