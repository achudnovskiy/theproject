//
//  HomeViewController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-03-05.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "HomeViewController.h"
#import "Business.h"
#import "AppDelegate.h"
#import "DetailsViewController.h"

@interface HomeViewController () <UICollectionViewDataSource>

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.count;
}


-(NSArray*) model
{
    if(!_model)
    {
        _model=((AppDelegate*)[[UIApplication sharedApplication] delegate]).model;
    }
    return _model;
}

//reaction for closest beacon in range
-(void) beaconActivatedWithMajor:(NSNumber*)major
{
}

-(void) beaconActivatedWithMajor:(NSNumber*)major withMinor:(NSNumber*)minor;
{
    //Beacon specific reaction
}

-(void) beaconLeft
{
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ListToBusiness"]){
        if ([segue.destinationViewController isKindOfClass:[DetailsViewController class]])
        {
            NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
            NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
            
            DetailsViewController *dest = (DetailsViewController *)segue.destinationViewController;
            dest.model =self.model;
            
            NSNumber *businessID=[[NSNumber alloc] initWithInteger:indexPath.row];
            
            [dest setBusinessToShow:businessID];
        }
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    UILabel *businessTitle = (UILabel *)[cell viewWithTag:100];
    businessTitle.text= ((Business*)self.model[indexPath.row]).name;
    
    return cell;
}

@end
