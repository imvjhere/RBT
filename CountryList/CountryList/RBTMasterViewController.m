#import "RBTMasterViewController.h"
#import "RBTFetchDataAPI.h"
#import "RBTCountry.h"
#import "RBTCountryTableViewCell.h"
#import "RBTDetailViewController.h"

@interface RBTMasterViewController () <UISearchResultsUpdating>

@property (nonatomic) RBTFetchDataAPI *fetchDataAPI;
@property (nonatomic) UISearchController *searchController;

@property (nonatomic) NSArray<RBTCountry *> *allCountries;
@property (nonatomic) NSArray<RBTCountry *> *filteredCountries;

@property (nonatomic) NSArray *alphabetsArray;

@end

@implementation RBTMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fetchDataAPI = [[RBTFetchDataAPI alloc] init];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    
    UISearchBar *searchBar = self.searchController.searchBar;
    
    self.tableView.tableHeaderView = searchBar;
    searchBar.placeholder = NSLocalizedString(@"Country name", @"Placeholder for countries search");
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    
    __weak typeof(self) weakSelf = self;
    [self.fetchDataAPI fetchCountryJson:^(BOOL success, NSError *error){
        if (success) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.allCountries = weakSelf.fetchDataAPI.fetchedCountries;
                
                [weakSelf createAlphabetArray];
                
                if (weakSelf.searchController.isActive)
                {
                    [weakSelf updateSearchResultsForSearchController:weakSelf.searchController];
                }
                else
                {
                    [weakSelf.tableView reloadData];
                }
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
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        RBTCountry *country = self.countries[indexPath.row];
        RBTDetailViewController *controller = (RBTDetailViewController *)segue.destinationViewController;
        controller.country = country;
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *query = self.searchController.searchBar.text;
    if (query.length != 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", query];
        self.filteredCountries = [self.allCountries filteredArrayUsingPredicate:predicate];
    }
    else
    {
        self.filteredCountries = self.allCountries;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Implemetations

- (NSArray<RBTCountry *> *)countries
{
    if (self.searchController.isActive)
    {
        return self.filteredCountries;
    }
    
    return self.allCountries;
}

// Creating a dynamic array for indexing country.
- (void)createAlphabetArray
{
    NSMutableArray *alphabetsArray = [[NSMutableArray alloc] init];
    NSMutableSet *letterStrings = [[NSMutableSet alloc] init];
    
    for (RBTCountry *country in self.allCountries)
    {
        NSString *firstLetterString = [country.name substringToIndex:1];
        if ([letterStrings containsObject:firstLetterString])
        {
            continue;
        }
        
        [letterStrings addObject:firstLetterString];
        [alphabetsArray addObject:firstLetterString];
    }
    
    self.alphabetsArray = [NSArray arrayWithArray:alphabetsArray];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.countries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"countryCell";
    RBTCountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    RBTCountry *country = self.countries[indexPath.row];
    cell.flageImageView.image = [UIImage imageNamed:country.alphaCode] ?
                            [UIImage imageNamed:country.alphaCode] : [UIImage imageNamed:@"countries.png"];
    cell.countryLabel.text = country.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.searchController.searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    for (int index = 0; index < self.countries.count; index++) {
        RBTCountry *country = [self.countries objectAtIndex:index];
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
    return self.alphabetsArray;
}

# pragma mark - Search

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
