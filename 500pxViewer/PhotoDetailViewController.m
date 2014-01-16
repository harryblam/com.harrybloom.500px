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

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *URL = [NSString stringWithFormat:@"https://api.500px.com/v1/photos/%zi?image_size=4&comments=1&consumer_key=%@", self.photoId, ConsumerAPIKey];
    
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
