//
//  RBTCountry.h
//  CountryList
//
//  Created by VijayG on 2017-06-22.
//  Copyright © 2017 Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBTCountry : NSObject

// The country properties
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *alphaCode;
@property (strong, nonatomic) NSString *nativeName;
@property (strong, nonatomic) NSString *capital;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSString *subregion;
@property (strong, nonatomic) NSURL *flag;

-(BOOL)didUpdateSucceedForCountryDictionary:(NSDictionary *)countryDictionary;

@end
