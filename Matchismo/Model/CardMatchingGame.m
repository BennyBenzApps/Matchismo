//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Benjamin Lavin on 2013-01-31.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

#define MATCH_BONUS 4;
#define MISMATCH_PENALTY 2;
#define FLIP_COST 1;

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards){
                if (otherCard.isFaceUp && !otherCard.isUnplayable){
                    int matchScore = [card match:@[otherCard]];
                    int points = 0;
                    if (matchScore){
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        points = matchScore * MATCH_BONUS;
                        self.score += points;
                        self.matchResult = [NSString stringWithFormat:@"Matched %@ & %@ for %d points", [card contents], [otherCard contents], points];
                    } else {
                        otherCard.faceUp = NO;
                        points = MISMATCH_PENALTY;
                        self.score -= points;
                        self.matchResult = [NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!", [card contents], [otherCard contents], points];
                    }
                    break;
                }
                self.matchResult = [NSString stringWithFormat:@"Flipped up %@",card.contents];
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++){
            Card *card = [deck drawRandomCard];
            if (card){
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

@end
