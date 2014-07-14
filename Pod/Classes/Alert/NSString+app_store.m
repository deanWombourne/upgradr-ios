//
//  NSString+app_store.m
//  Pods
//
//  Created by Sam Dean on 14/07/2014.
//
//

#import "NSString+app_store.h"

@implementation NSString (app_store)

- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet *)set {
    return [[self componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
}

- (NSString *)DW_appStoreSafeString {
    NSString *safe = [self copy];

    // Following the instructions here : https://developer.apple.com/library/ios/qa/qa1633/_index.html

    // 1) Remove whitespace
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    safe = [safe stringByRemovingCharactersInSet:whitespace];

    // 2) Convert to lowercase
    safe = [safe lowercaseString];

    // 3) Remove all copyright (©), trademark (™) and registered mark (®) symbols
    NSCharacterSet *remove = [NSCharacterSet characterSetWithCharactersInString:@"©™®"];
    safe = [safe stringByRemovingCharactersInSet:remove];

    // 4) Relpace & with 'and'
    safe = [safe stringByReplacingOccurrencesOfString:@"&" withString:@"and"];

    // 5) Remove punctuation
    NSCharacterSet *punc = [NSCharacterSet characterSetWithCharactersInString:@"!¡\"#$%'()*+,\\-./:;<=>¿?@[\\]^_`{|}~"];
    safe = [safe stringByRemovingCharactersInSet:punc];

    // 6) Remove diacritics
    NSMutableString *final = [safe mutableCopy];
    CFStringTransform((CFMutableStringRef)final, nil, kCFStringTransformStripCombiningMarks, NO);

    return final;
}

@end
