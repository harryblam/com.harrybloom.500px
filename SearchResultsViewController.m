//
//  SearchResultsViewController.m
//  500pxViewer
//
//  Created by Harry Bloom on 16/01/2014.
//  Copyright (c) 2014 Harry Bloom. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "Contants.h"
#import "ImageCollectionViewCell.h"
#import "PhotoDetailViewController.h"

@interface SearchResultsViewController ()

//@property (strong, nonatomic) NSDictionary * responseDict;
@property (strong, nonatomic) NSArray * imagesArray;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.searchTerm capitalizedString];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *URL = [NSString stringWithFormat:@"https://api.500px.com/v1/photos/search?consumer_key=%@&term=%@", ConsumerAPIKey, self.searchTerm];
    
    [self getImagesWithSearchTerm:URL];
}

- (void)getImagesWithSearchTerm:(NSString *)URL
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        self.imagesArray = responseObject[@"photos"];
        
        NSLog(@"JSON: %@", self.imagesArray);
        
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.imagesArray[indexPath.row];
    
    NSURL *imageURL = [NSURL URLWithString:dict[@"image_url"]];
    
    [cell.imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Loading"]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *index = [[self.collectionView indexPathsForSelectedItems]lastObject];
    
    PhotoDetailViewController *destVC = segue.destinationViewController;
    
    destVC.photoId = [self.imagesArray[index.item][@"id"] integerValue];
    
     NSLog(@"Photo ID: %zi", destVC.photoId);
    
}

@end
