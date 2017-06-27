#import "RBTDetailViewController.h"
#import "RBTCountry.h"

@interface RBTDetailViewController()

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *alphaCodeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nativeNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *capitalCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *regionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *subRegionCell;

@end

@implementation RBTDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
}

- (void)setupTableView
{
    self.flagImageView.image = [UIImage imageNamed:self.country.alphaCode] ?
    [UIImage imageNamed:self.country.alphaCode] : [UIImage imageNamed:@"countries.png"];
    
    NSString *unknown = NSLocalizedString(@"Unknown", @"Placeholder for unknown property");
    
    RBTCountry *country = self.country;
    
    self.nameCell.textLabel.text = NSLocalizedString(@"Country Name", @"Name of the country");
    self.nameCell.detailTextLabel.text = country.name ? country.name : unknown;
    
    self.alphaCodeCell.textLabel.text = NSLocalizedString(@"Alpha Code", @"Alpha Code of the country");
    self.alphaCodeCell.detailTextLabel.text = country.alphaCode ? country.alphaCode : unknown;
    
    self.nativeNameCell.textLabel.text = NSLocalizedString(@"Native Name", @"Native Name of the country");
    self.nativeNameCell.detailTextLabel.text = country.nativeName ? country.nativeName : unknown;
    
    self.capitalCell.textLabel.text = NSLocalizedString(@"Capital Country", @"Capital of the country");
    self.capitalCell.detailTextLabel.text = country.capital ? country.capital : unknown;
    
    self.regionCell.textLabel.text = NSLocalizedString(@"Region", @"Region the country belongs to");
    self.regionCell.detailTextLabel.text = country.region ? country.region : unknown;
    
    self.subRegionCell.textLabel.text = NSLocalizedString(@"Sub Region", @"Sub Region");
    self.subRegionCell.detailTextLabel.text = country.subregion ? country.subregion : unknown;
}

@end
