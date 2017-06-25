//
//  ViewController.m
//  CountryList
//
//  Created by VijayG on 2017-06-22.
//  Copyright © 2017 Org. All rights reserved.
//

#import "RBTMasterViewController.h"
#import "RBTFetchDataAPI.h"
#import "RBTCountry.h"
#import "RBTCountryTableViewCell.h"
#import "RBTDetailViewController.h"

@interface RBTMasterViewController () <UISearchBarDelegate>

@property (nonatomic) RBTFetchDataAPI *fetchDataAPI;
@property (nonatomic) NSString *cellIdentifier;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) NSArray *resultsArray;
@property (nonatomic) NSMutableArray *alphabetsArray;

@end

@implementation RBTMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cellIdentifier = @"countryCell";
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.fetchDataAPI = [[RBTFetchDataAPI alloc] init];
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;

    [self.fetchDataAPI fetchCountryJson:^(BOOL success, NSError *_Nonnull error){
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateResults];
                [self createAlphabetArray];
                [self.tableView reloadData];
            });
        } else {
            // TODO: Handle alert
        }
    }];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RBTCountry *country = self.resultsArray[indexPath.row];
        RBTDetailViewController *controller = (RBTDetailViewController *)
                                                [[segue destinationViewController] self];
        controller.country = country;
    }
}

#pragma mark - Implemetations

- (void)updateResults
{
    NSArray *fetchedCountries = self.fetchDataAPI.fetchedCountries;
    if (!fetchedCountries) {
        self.resultsArray = nil;
        return;
    }
    
    if ([self.searchBar.text length] == 0) {
        self.resultsArray = fetchedCountries;
    } else {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@",
                                      self.searchBar.text];
            self.resultsArray = [[fetchedCountries filteredArrayUsingPredicate:predicate] mutableCopy];
    }
}

// Creating a dynamic array for indexing country.
- (void)createAlphabetArray
{
    NSMutableArray *tempFirstLetterArray = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < [self.resultsArray count]; index++) {
        RBTCountry *country = [self.resultsArray objectAtIndex:index];
        NSString *letterString = [country.name substringToIndex:1];
        if (![tempFirstLetterArray containsObject:letterString]) {
            [tempFirstLetterArray addObject:letterString];
        }
    }
    
    self.alphabetsArray = tempFirstLetterArray;
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // Fixed number of section.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultsArray.count > 0 ? self.resultsArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RBTCountryTableViewCell *cell = (RBTCountryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if (!cell) {
        cell = [[RBTCountryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:self.cellIdentifier];
    }
    
    RBTCountry *country = (RBTCountry *) self.resultsArray[indexPath.row];
    cell.flageImageView.image = [UIImage imageNamed:country.alphaCode] ?
                            [UIImage imageNamed:country.alphaCode] : [UIImage imageNamed:@"countries.png"];
    cell.countryLabel.text = country.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissSearchKeyboard];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    for (int index = 0; index < self.resultsArray.count; index++) {
        RBTCountry *country = [self.resultsArray objectAtIndex:index];
        NSString *letterString = [country.name substringToIndex:1];
        
        if ([letterString isEqualToString:title]) {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        }
    }
    return -1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.alphabetsArray != nil ? self.alphabetsArray : nil;
}

# pragma mark - Search

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self updateResults];
    [self.tableView reloadData];
}

- (void)dismissSearchKeyboard
{
    // Resign first responder status of the search bar
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

/// ** If only the flag url was in PNG format, since flag is in svg format, couldn't use this method.
//- (void)lazyLoadAndCacheImageOfAlphaCode:(NSString *)alphaCode url:(NSURL *)imageUrl forIndexPath:(NSIndexPath *)indexPath
//{
//    // Download the avatar images for the results cells on a background thread for best UI update and scrolling performance
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *flagImageData = [NSData dataWithContentsOfURL:imageUrl];
//
//        if (flagImageData) {
//            UIImage *flagImage = [UIImage imageWithData:flagImageData];
//
//            if (flagImage) {
//                // Cache image
//                [self.imageCache setObject:flagImage forKey: alphaCode];
//
//                // If we have a valid avatar image, update the relevant results cell on the main thread
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    RBTCountryTableViewCell *countryCell = (RBTCountryTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//                    countryCell.imageView.image = flagImage;
//                });
//            }
//        }
//    });
//}

@end
