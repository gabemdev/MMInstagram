//
//  SearchViewController.m
//  MMInstagram
//
//  Created by Rockstar. on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCollectionViewCell.h"

@interface SearchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property NSArray *photos;
@property NSArray *users;
@property PFUser *user;
@property NSInteger photoIndexPath;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos = [NSArray new];
    self.users = [NSArray new];
    [self retrievePhotos];
    [self retrieveUsers];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self retrieveUsers];
    [self retrievePhotos];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

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


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    PFUser *user = self.users[indexPath.row];
    cell.textLabel.text = user.username;

    PFFile *file = [user objectForKey:@"imageFile"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
            cell.imageView.image = [UIImage imageWithData:data];
        }
    }];
    return cell;
}


#pragma mark - Accessor Methods
- (void)retrievePhotos {
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            self.photos = objects;
            [self.collectionView reloadData];

        }
    }];
}

- (void)retrieveUsers {
    PFQuery *query = [PFUser query];
    [query orderByDescending:@"cretedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            self.users = objects;
            [self.tableView reloadData];
        }
    }];
}

- (IBAction)segmentControlTapped:(id)sender {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    } else if (self.segmentControl.selectedSegmentIndex == 1) {
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
        [self.tableView reloadData];
    }
}


#pragma mark - SearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.segmentControl.selectedSegmentIndex == 0) {

        PFQuery *searchQuery = [PFUser query];
        [searchQuery whereKey:@"objectId" containsString:searchText];
        [searchQuery orderByDescending:@"createdAt"];
        [searchQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                self.photos = objects;
                [self.collectionView reloadData];
            }
        }];

    } else if (self.segmentControl.selectedSegmentIndex == 1) {

        PFQuery *searchQuery = [PFUser query];
        [searchQuery whereKey:@"username" hasPrefix:searchText];
        [searchQuery orderByDescending:@"createdAt"];
        [searchQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                self.users = objects;
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


@end
