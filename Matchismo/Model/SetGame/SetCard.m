//
//  SetCard.m
//  Matchismo
//
//  Created by Benjamin Lavin on 2013-02-28.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

#define MAX_NUM 3

+ (NSArray *)validSymbols {
    return @[@"▲",@"●",@"■"];
}

+ (NSArray *)validColors {
    return @[@"red",@"green",@"purple"];
}

+ (NSArray *)validShadings {
    return @[@"solid",@"striped",@"open"];
}

+ (NSUInteger)maxNumber{
    return MAX_NUM;
}

- (NSString *)contents{
    
    NSString *myString = @"";
    for (NSUInteger i = 0; i < self.number; i++){
        myString = [myString stringByAppendingString:self.symbol];
    }
    return myString;
}

- (void)setSymbol:(NSString  *)symbol {
    if ([[SetCard validSymbols] containsObject:symbol]){
        _symbol = symbol;
    }
}

- (void)setNumber:(NSUInteger)number {
    if (number <= [SetCard maxNumber]){
        _number = number;
    }
}

- (void)setColor:(NSString *)color{
    if ([[SetCard validColors] containsObject:color]){
        _color = color;
    }
}

- (void)setShading:(NSString *)shading{
    if ([[SetCard validShadings] containsObject:shading]){
        _shading = shading;
    }
}

@end
