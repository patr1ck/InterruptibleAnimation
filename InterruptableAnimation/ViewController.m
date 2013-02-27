//
//  ViewController.m
//  InterruptableAnimation
//
//  Created by Patrick B. Gibson on 1/10/13.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    DraggableView *dv = [[DraggableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:dv];
    self.draggableView = dv;
    self.draggableView.backgroundColor = [UIColor blueColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    label.text = @"Drag Me";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blueColor];
    [self.draggableView addSubview:label];
    
    [self.draggableView setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
