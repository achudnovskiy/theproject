//
//  ProfileController.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-06-18.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "ProfileController.h"
#import "Model.h"
#import "User.h"
#import "Tag.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *interestsCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *BackToFeed;

@property (nonatomic, strong) NSArray* interests;
@end

@implementation ProfileController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    User* currentUser=[Model sharedModel].currentUser;
    if(currentUser)
    {
        self.profilePic.image=[UIImage imageWithData:currentUser.pic];
        self.nameLabel.text=currentUser.name;
    }
    else
    {
        self.profilePic.image=[UIImage imageNamed:@"default_user"];
        self.nameLabel.text=@"Stranger";
    }

    
    CALayer *imageLayer = self.profilePic.layer;
    imageLayer.cornerRadius=self.profilePic.frame.size.width/2;
    imageLayer.borderWidth=1;
    imageLayer.borderColor=[UIColor grayColor].CGColor;
    imageLayer.masksToBounds=YES;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.interests=[[[Model sharedModel] getInterests] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];

    if(self.afterRegistration)
    {
        self.afterRegistration=nil;
        self.BackToFeed.hidden=NO;
    }
    else
        self.BackToFeed.hidden=YES;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell *cell = [self.interestsCollection cellForItemAtIndexPath:indexPath];
  
    UIView* outterView=[cell viewWithTag:2];

    UILabel *interestLabel = (UILabel *)[cell viewWithTag:1];
    interestLabel.userInteractionEnabled=NO;

    Tag* interest=(Tag*)self.interests[indexPath.row];
    if([interest.likeness doubleValue]>=[[Model sharedModel].interest_value doubleValue])
    {
        interest.likeness=@(0);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        outterView.backgroundColor=[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
        interestLabel.textColor=[UIColor colorWithRed:60/255.0 green:81.0/255.0 blue:83.0/255.0 alpha:1];
        [UIView commitAnimations];

    }
    else
    {
        interest.likeness=[Model sharedModel].interest_value;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        outterView.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:148.0/255.0 blue:83.0/255.0 alpha:1];
        interestLabel.textColor=[UIColor whiteColor];
        [UIView commitAnimations];

    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.interests.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InterestCell" forIndexPath:indexPath];
    
    UIView* outterView=[cell viewWithTag:2];
    outterView.layer.cornerRadius=8;
    outterView.layer.borderWidth=1;
    outterView.layer.borderColor=[UIColor darkGrayColor].CGColor;
    
    UILabel *interestLabel = (UILabel *)[cell viewWithTag:1];
    Tag* interest=(Tag*)self.interests[indexPath.row];

    interestLabel.text=interest.name;
    if([interest.likeness doubleValue]>=[[Model sharedModel].interest_value doubleValue])
    {
        outterView.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:148.0/255.0 blue:83.0/255.0 alpha:1];
        interestLabel.textColor=[UIColor whiteColor];
    }
    else
    {
        outterView.backgroundColor=[UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
        interestLabel.textColor=[UIColor colorWithRed:60/255.0 green:81.0/255.0 blue:83.0/255.0 alpha:1];
    }

    return cell;
}


@end
