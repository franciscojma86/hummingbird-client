//
//  StatusFilterTVC.m
//  HummingBird
//
//  Created by Francisco Magdaleno on 3/8/16.
//  Copyright © 2016 franciscojma86. All rights reserved.
//

#import "StatusFilterTVC.h"

@interface StatusFilterTVC ()

@property (nonatomic,strong) NSArray *options;

@end

@implementation StatusFilterTVC

#define CELL_IDENTIFIER @"status_filter_cell_identifier"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.options = @[@"Currently watching",
                     @"Plan to watch",
                     @"Completed",
                     @"On hold",
                     @"Dropped"];
}


#pragma mark -Tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CELL_IDENTIFIER];
    }
    [cell.textLabel setText:self.options[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate statusFilterTV:self
                  didSelectStatus:self.options[indexPath.row]];
}

@end
