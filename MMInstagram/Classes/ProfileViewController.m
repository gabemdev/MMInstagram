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
#import "EditProfileViewController.h"
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
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property NSMutableArray *photos;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;

    self.editButton.layer.cornerRadius = 3;
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
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                self.profileImageView.image = [UIImage imageWithData:data];
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
                self.profileImageView.layer.masksToBounds = YES;
                self.profileImageView.layer.borderColor = [UIColor colorWithRed:0.92 green:0.38 blue:0.38 alpha:1.00].CGColor;
                self.profileImageView.layer.borderWidth = 3;
            }
        }];
    }
}

- (void)loadPhotos {
    self.photos = [NSMutableArray new];
    PFUser *user = [PFUser currentUser];
    if (user) {
        PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
        [query includeKey:@"user"];
        [query whereKey:@"user" equalTo:user];
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
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
    if ([segue.identifier isEqualToString:@"editProfile"]) {
        PFUser *selected = [PFUser currentUser];
        EditProfileViewController *vc = segue.destinationViewController;
        vc.user = selected;
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];

    } else if ([segue.identifier isEqualToString:@"showImageDetail"]) {
    SearchCollectionViewCell *cell = sender;
    ProfilePhotoDetailViewController *vc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    vc.photo = self.photos[indexPath.row];
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }

}
@end
