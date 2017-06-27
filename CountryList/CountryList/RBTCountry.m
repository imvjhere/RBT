#import "RBTCountry.h"

@implementation RBTCountry

-(instancetype) init
{
    self = [super init];
    
    if (self)
    {
        self.name = nil;
        self.nativeName = nil;
        self.capital = nil;
        self.region = nil;
        self.alphaCode = nil;
        self.subregion = nil;
        self.flag = nil;
    }
    
    return self;
}

-(BOOL)didUpdateSucceedForCountryDictionary:(NSDictionary *)countryDictionary
{
    NSString *name = countryDictionary[@"name"];
    NSString *nativeName = countryDictionary[@"nativeName"];
    NSString *capital = countryDictionary[@"capital"];
    NSString *region = countryDictionary[@"region"];
    NSString *alphaCode = countryDictionary[@"alpha2Code"];
    NSString *subregion = countryDictionary[@"subregion"];
    
    NSString *flagUrlString = countryDictionary[@"flag"];
    NSURL *flagUrl = [NSURL URLWithString:flagUrlString];
    
    // Check if the dictionary objects are not nil and valid.
    // Update country only for valid dictionary
    if (name &&
        nativeName &&
        capital &&
        region &&
        alphaCode &&
        subregion &&
        flagUrl)
    {
        [self updateCountryObjectsForAlphaCode:alphaCode
                                          name:name
                                    nativeName:nativeName
                                       capital:capital
                                        region:region
                                     subregion:subregion
                                       flagUrl:flagUrl];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)updateCountryObjectsForAlphaCode:(NSString *)alphaCode
                                    name:(NSString *)name
                              nativeName:(NSString *)nativeName
                                 capital:(NSString *)capital
                                  region:(NSString *)region
                               subregion:(NSString *)subregion
                                 flagUrl:(NSURL *)flagUrl
{
    self.name = name;
    self.alphaCode = alphaCode;
    self.nativeName = nativeName;
    self.capital = capital;
    self.region = region;
    self.subregion = subregion;
    self.flag = flagUrl;
}

@end
