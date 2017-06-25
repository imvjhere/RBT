//
//  RBTFetchDataAPI.h
//  CountryList
//
//  Created by VijayG on 2017-06-22.
//  Copyright © 2017 Org. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const RBTFetchDataErrorDomain;

typedef NS_OPTIONS(NSUInteger, RBTFetchDataErrorCode) {
    RBTFetchDataErrorCodeServerError,
    RBTFetchDataErrorCodeJSONDataError,
    RBTFetchDataErrorCodeNetworkError,
    RBTFetchDataErrorCodeUnknownError
};

@interface RBTFetchDataAPI : NSObject

@property (nonatomic, readonly) NSArray *fetchedCountries;

typedef void (^RBTDataCompletion)(BOOL success, NSError* error);
- (void)fetchCountryJson:(RBTDataCompletion)completion;

@end
