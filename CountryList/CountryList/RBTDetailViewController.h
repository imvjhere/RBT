//
//  RBTDetailViewController.h
//  CountryList
//
//  Created by VijayG on 2017-06-22.
//  Copyright © 2017 Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RBTCountry;

@interface RBTDetailViewController : UITableViewController

- (void)setCountry:(RBTCountry *)country;

@end
