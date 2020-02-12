//
//  ViewController.m
//  HYPlayer
//
//  Created by templechen on 2020/2/11.
//  Copyright © 2020 templechen. All rights reserved.
//

#import "ViewController.h"
#import "GLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GLView *glView = [[GLView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:glView];
}


@end
