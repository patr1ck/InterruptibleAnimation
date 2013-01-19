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
    
    [self.draggableView setup];
    self.draggableView.dragsHorizontally = YES;
    self.draggableView.dragsVertically = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
