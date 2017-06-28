#import "RBTCountry.h"

@interface RBTCountry ()

@property (nonatomic, readwrite) NSDictionary *dictionaryRepresentation;

@end

@implementation RBTCountry

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self)
    {
        self.dictionaryRepresentation = dictionary;
    }
    
    return self;
}

- (NSString *)name
{
    return self.dictionaryRepresentation[@"name"];
}

- (NSString *)alphaCode
{
    return self.dictionaryRepresentation[@"alpha2Code"];
}

- (NSString *)nativeName
{
    return self.dictionaryRepresentation[@"nativeName"];
}
- (NSString *)capital
{
    return self.dictionaryRepresentation[@"capital"];
}
- (NSString *)region
{
    return self.dictionaryRepresentation[@"region"];
}

- (NSString *)subregion
{
    return self.dictionaryRepresentation[@"subregion"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", super.description, self.dictionaryRepresentation];
}

@end
