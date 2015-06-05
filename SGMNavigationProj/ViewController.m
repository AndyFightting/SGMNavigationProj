//
//  ViewController.m
//  SGMNavigationProj
//
//  Created by guimingsu on 15/6/5.
//  Copyright (c) 2015年 guimingsu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{

    UIButton* hideNavBt;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [self randomColor];
    self.title = @"Define IOS7 PenGesture";
    
    
    hideNavBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 40)];
    [hideNavBt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [hideNavBt addTarget:self action:@selector(hideNavBt:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideNavBt];
    
    
    UIButton* bt = [[UIButton alloc]initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 40)];
    [bt setTitle:@"PUSH ME BABY !" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(btTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (!self.navigationController.navigationBarHidden) {
        [hideNavBt setTitle:@"Hide Navigation" forState:UIControlStateNormal];
    }else{
        [hideNavBt setTitle:@"Show Navigation" forState:UIControlStateNormal];
    }
}

-(void)hideNavBt:(UIButton*)button{
    
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [button setTitle:@"Hide Navigation" forState:UIControlStateNormal];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [button setTitle:@"Show Navigation" forState:UIControlStateNormal];
    }


}

-(void)btTap:(UIButton*)button{

    ViewController * v = [[ViewController alloc]init];
    [self.navigationController pushViewController:v animated:YES];

}

-(UIColor *)randomColor {
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
