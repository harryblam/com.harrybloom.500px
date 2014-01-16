//
//  ViewController.m
//  500pxViewer
//
//  Created by Harry Bloom on 16/01/2014.
//  Copyright (c) 2014 Harry Bloom. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultsViewController.h"

@interface SearchViewController ()

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.searchTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SearchResultsViewController *destVC = [segue destinationViewController];
    destVC.searchTerm = [self.searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self performSegueWithIdentifier:@"searchSegue" sender:self];
    
    
    //THIS IS A CHANGE
    
    return YES;
}

@end
