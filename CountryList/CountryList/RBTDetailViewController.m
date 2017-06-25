//
//  RBTDetailViewController.m
//  CountryList
//
//  Created by VijayG on 2017-06-22.
//  Copyright © 2017 Org. All rights reserved.
//

#import "RBTDetailViewController.h"
#import "RBTCountry.h"

@interface RBTDetailViewController()

@property (weak, nonatomic) RBTCountry *country;

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

- (void)setCountry:(RBTCountry *)country
{
    if (_country != country)
    {
        _country = country;
        [self setupTableView];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.country.name;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
    }
}

- (void)setupTableView
{
    self.flagImageView.image = [UIImage imageNamed:self.country.alphaCode] ?
    [UIImage imageNamed:self.country.alphaCode] : [UIImage imageNamed:@"countries.png"];
    
    // NameCell
    self.nameCell.textLabel.text = NSLocalizedString(@"Country Name", @"Name of the country");
    self.nameCell.detailTextLabel.text = self.country.name;
    
    // AlphaCodeCell
    self.alphaCodeCell.textLabel.text = NSLocalizedString(@"Alpha Code", @"Alpha Code of the country");
    self.alphaCodeCell.detailTextLabel.text = self.country.alphaCode;
    
    // NativeNameCell
    self.nativeNameCell.textLabel.text = NSLocalizedString(@"Native Name", @"Native Name of the country");
    self.nativeNameCell.detailTextLabel.text = self.country.nativeName;
    
    // CapitalCell
    self.capitalCell.textLabel.text = NSLocalizedString(@"Capital Country", @"Capital of the country");
    self.capitalCell.detailTextLabel.text = self.country.capital;
    
    // RegionCell
    self.regionCell.textLabel.text = NSLocalizedString(@"Region", @"Region the country belongs to");
    self.regionCell.detailTextLabel.text = self.country.region;
    
    // SubRegionCell
    self.subRegionCell.textLabel.text = NSLocalizedString(@"Sub Region", @"Sub Region");
    self.subRegionCell.detailTextLabel.text = self.country.subregion;
}

@end
