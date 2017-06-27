#import "RBTMasterViewController.h"
#import "RBTFetchDataAPI.h"
#import "RBTCountry.h"
#import "RBTCountryTableViewCell.h"
#import "RBTDetailViewController.h"
#import "RBTCountriesSection.h"

@interface RBTMasterViewController () <UISearchResultsUpdating>

@property (nonatomic) RBTFetchDataAPI *fetchDataAPI;
@property (nonatomic) UISearchController *searchController;

@property (nonatomic) NSArray<RBTCountriesSection *> *sections;

@property (nonatomic) NSArray<RBTCountry *> *filteredCountries;

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
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
        
    __weak typeof(self) weakSelf = self;
    [self.fetchDataAPI fetchCountryJson:^(BOOL success, NSError *error){
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                NSArray<RBTCountry *> *countries = [weakSelf.fetchDataAPI.fetchedCountries sortedArrayUsingDescriptors:@[ sortDescriptor ]];
                
                NSMutableArray<RBTCountriesSection *> *sections = [[NSMutableArray alloc] init];
                RBTCountriesSection *currentSection;
                NSMutableArray<RBTCountry *> *currentCountries = [[NSMutableArray alloc] init];
                for (RBTCountry *country in countries)
                {
                    NSString *firstLetter = [country.name substringToIndex:1];
                    if (![currentSection.title isEqualToString:firstLetter])
                    {
                        if (currentSection)
                        {
                            currentSection.countries = [NSArray arrayWithArray:currentCountries];
                            [currentCountries removeAllObjects];
                            
                            [sections addObject:currentSection];
                        }
                        
                        currentSection = [[RBTCountriesSection alloc] init];
                        currentSection.title = firstLetter;
                    }
                    
                    [currentCountries addObject:country];
                }
                
                self.sections = [NSArray arrayWithArray:sections];
                
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
        
        RBTCountry *country = [self countryForIndexPath:indexPath];
        RBTDetailViewController *controller = (RBTDetailViewController *)segue.destinationViewController;
        controller.country = country;
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *query = self.searchController.searchBar.text;
    NSPredicate *predicate = (query.length != 0) ? [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", query] : nil;
    
    NSMutableArray *filteredCountries = [[NSMutableArray alloc] init];
    for (RBTCountriesSection *section in self.sections)
    {
        NSArray<RBTCountry *> *countries = predicate ? [section.countries filteredArrayUsingPredicate:predicate] : section.countries;
        [filteredCountries addObjectsFromArray:countries];
    }
    
    self.filteredCountries = [NSArray arrayWithArray:filteredCountries];
    
    [self.tableView reloadData];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.isActive)
    {
        return 1;
    }
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.isActive)
    {
        return self.filteredCountries.count;
    }
    
    RBTCountriesSection *countriesSection = self.sections[section];
    return countriesSection.countries.count;
}

- (RBTCountry *)countryForIndexPath:(NSIndexPath *)indexPath
{
    RBTCountry *country;
    
    if (self.searchController.isActive)
    {
        country = self.filteredCountries[indexPath.row];
    }
    else
    {
        RBTCountriesSection *section = self.sections[indexPath.section];
        country = section.countries[indexPath.row];
    }
    
    return country;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"countryCell";
    RBTCountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    RBTCountry *country = [self countryForIndexPath:indexPath];
    
    cell.flageImageView.image = [UIImage imageNamed:country.alphaCode] ? [UIImage imageNamed:country.alphaCode] : [UIImage imageNamed:@"countries.png"];
    cell.countryLabel.text = country.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.searchController.searchBar resignFirstResponder];
}

# pragma mark - Sectioning

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchController.isActive)
    {
        return nil;
    }
    
    RBTCountriesSection *countriesSection = self.sections[section];
    return countriesSection.title;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.searchController.isActive)
    {
        return -1;
    }
    
    if (index == 0)
    {
        UISearchBar *searchBar = self.searchController.searchBar;
        [tableView scrollRectToVisible:searchBar.bounds animated:YES];
        
        return -1;
    }
    
    NSUInteger sectionIndex = [self.sections indexOfObjectPassingTest:^BOOL(RBTCountriesSection *section, NSUInteger index, BOOL *stop) {
        if ([section.title isEqualToString:title])
        {
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
    
    return sectionIndex;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.isActive)
    {
        return nil;
    }
    
    NSArray *collationSectionIndexTitles = [self.sections valueForKey:@"title"];
    return [@[UITableViewIndexSearch] arrayByAddingObjectsFromArray:collationSectionIndexTitles];
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
