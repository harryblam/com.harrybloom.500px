//
//  PhotoDetailViewController.m
//  500pxViewer
//
//  Created by Harry Bloom on 16/01/2014.
//  Copyright (c) 2014 Harry Bloom. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Contants.h"

@interface PhotoDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) NSDictionary *imageDetails;
@property (strong, nonatomic) UIActivityIndicatorView *progressIndicator;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.progressIndicator];
    [self.progressIndicator startAnimating];

    
    NSString *URL = [NSString stringWithFormat:@"https://api.500px.com/v1/photos/%zi?image_size=4&comments=1&consumer_key=%@", self.photoId, ConsumerAPIKey];
    
    //Use NSDictionary of parameters and pass it to the AFNetworking function
    
    [self loadPhotoDetail:URL];
}

- (void)loadPhotoDetail:(NSString *)URL
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        self.imageDetails = responseObject;
        
        NSLog(@"JSON: %@", self.imageDetails);
        
        self.title = self.imageDetails[@"photo"][@"user"][@"fullname"];
        
        NSURL *imageURL = [NSURL URLWithString:self.imageDetails[@"photo"][@"image_url"]];
        
        [self.detailImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Loading"]];
        
        [self.tableView reloadData];
        [self.progressIndicator stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.progressIndicator stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Error: %@", error);
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *camera = self.imageDetails[@"photo"][@"camera"];
    
    if (camera == nil) {
        return @"Camera used: N/A";
    }
    return [NSString stringWithFormat:@"Camera used: %@", camera];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSInteger rating = [self.imageDetails[@"photo"][@"rating"] integerValue];
    
    if(rating == 0){
        return @"No ratings have been given yet";
    }else{
        return [NSString stringWithFormat:@"Rating: %zi", rating];
    }

}

@end
