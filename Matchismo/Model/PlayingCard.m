//
//  PlayingCard.m
//  cardApp
//
//  Created by Benjamin Lavin on 2013-01-30.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents{
    
    NSArray *rankStrings =  [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide setter AND getter

+ (NSArray *)validSuits {
    return @[@"♥",@"♦",@"♠",@"♣"];
}

+ (NSArray *)rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank {
    return [self rankStrings].count-1;
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}


- (NSString *)suit{
    return _suit ? _suit : @"?";
}
@end
