//
//  HomeViewController.m
//  CLNavcontroller
//
//  Created by chuliangliang on 16/10/17.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import "HomeViewController.h"
#import "PushViewController.h"
#import "CLBasicNav.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"HOME";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    ((CLBasicNav*)self.navigationController).mOrientation = CLAnimateRotation_antiClockwise;
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

- (IBAction)pushAction:(UIButton *)sender {
    [self.navigationController pushViewController:[[PushViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}
@end
