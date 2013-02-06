//
//  PlayingCard.m
//  cardApp
//
//  Created by Benjamin Lavin on 2013-01-30.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]){
            score = 1;
        } else if (otherCard.rank == self.rank){
            score = 4;
        }
    } else if ([otherCards count] == 2) {
        PlayingCard *secondCard = [otherCards objectAtIndex:0];
        PlayingCard *thirdCard = [otherCards lastObject];
        if ([secondCard.suit isEqualToString:self.suit] && [thirdCard.suit isEqualToString:self.suit]){
            score = 2;
        } else if (secondCard.rank == self.rank && thirdCard.rank == self.rank){
            score = 8;
        }
    }
    
    return score;
}


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
