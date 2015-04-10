//
//  ProfileViewController.m
//  MMInstagram
//
//  Created by Rockstar. on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ProfileViewController.h"
#import "SearchCollectionViewCell.h"
#import "ProfilePhotoDetailViewController.h"
#import "Photo.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (nonatomic) UIImage *selectedImage;
@property NSString *userName;

@property NSMutableArray *photos;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    [self getProfile];
    [self loadPhotos];
}




- (void)getProfile {
    PFUser *current = [PFUser currentUser];
    if (current) {
        self.navigationItem.title = current[@"name"];
        PFFile *imageData = [current objectForKey:@"profileImage"];
        [imageData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                self.profileImageView.image = [UIImage imageWithData:data];
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
                self.profileImageView.layer.masksToBounds = YES;
                self.profileImageView.layer.borderColor = [UIColor colorWithRed:0.59 green:0.60 blue:0.62 alpha:1.00].CGColor;
                self.profileImageView.layer.borderWidth = 4;
            }
        }];
    }
}

- (void)loadPhotos {
    self.photos = [NSMutableArray new];
    PFUser *user = [PFUser currentUser];
    if (user) {
        PFQuery *query = [Photo query];
        [query includeKey:@"user"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (Photo *photo in objects) {
                [self.photos addObject:photo];
            }
            [self.collectionView reloadData];
            self.postsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.photos.count];
        }];
    }

}


#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject *photo = self.photos[indexPath.row];
    PFFile *file = [photo objectForKey:@"imageFile"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            cell.imageView.image = [UIImage imageWithData:data];
        }
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}


#pragma mark - Actions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"photoViewSegue"])
//    {
////        UICollectionViewCell *cell = sender;
////        ProfilePhotoDetailViewController *vc = segue.destinationViewController;
////        vc.selected = [self.photos objectAtIndex:[self.collectionView indexPathForCell:cell].row];
////        vc.photo = [self.photos objectAtIndex:[self.collectionView indexPathForCell:cell].row];
//    }
    if ([segue.identifier isEqualToString:@"editProfile"]) {

    } else if ([segue.identifier isEqualToString:@"showImageDetail"]) {
    SearchCollectionViewCell *cell = sender;
    ProfilePhotoDetailViewController *vc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    vc.photo = self.photos[indexPath.row];
    }

}
@end
