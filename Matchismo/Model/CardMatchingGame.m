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

- (NSString *)matchResult {
    if (!_matchResult) _matchResult = [NSString stringWithFormat:@"2 card game. Pick a card!"];
    return _matchResult;
}

#define MATCH_BONUS 4;
#define MISMATCH_PENALTY 2;
#define FLIP_COST 1;

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (self.gameMode == 0){
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
            else {
                self.matchResult = [NSString stringWithFormat:@"%@ flipped down", [card contents]];
            }
            card.faceUp = !card.isFaceUp;
        }
    }
    else if (self.gameMode == 1){
        NSMutableArray *otherCards = [[NSMutableArray alloc] init];
        if (card && !card.isUnplayable) {
            if (!card.isFaceUp) {
                for (Card *otherCard in self.cards){
                    if (otherCard.isFaceUp && !otherCard.isUnplayable){
                        [otherCards addObject:otherCard];
                    }
                }
                    if (otherCards.count == 2){ //array has 2 cards
                        int matchScore = [card match:otherCards];
                        int points = 0;
                        Card *secondCard = [otherCards objectAtIndex:0];
                        Card *thirdCard = [otherCards lastObject];
                        if (matchScore){
                            card.unplayable = YES;
                            secondCard.unplayable = YES;
                            thirdCard.unplayable = YES;
                            points = matchScore * MATCH_BONUS;
                            self.score += points;
                            self.matchResult = [NSString stringWithFormat:@"Matched %@, %@, & %@ for %d points", [card contents], [secondCard contents], [thirdCard contents], points];
                        } else {
                            secondCard.faceUp = NO;
                            thirdCard.faceUp = NO;
                            points = MISMATCH_PENALTY;
                            self.score -= points;
                            self.matchResult = [NSString stringWithFormat:@"%@, %@, & %@ don't match! %d point penalty!", [card contents], [secondCard contents], [thirdCard contents], points];
                        }
                    }
                    else if (otherCards.count == 1) { //array has 1 card
                        self.matchResult = [NSString stringWithFormat:@"%@ flipped up. Pick 1 more card!", [card contents]];
                    }
                    else if (otherCards.count == 0) { //array has 0 cards
                        self.matchResult = [NSString stringWithFormat:@"%@ flipped up. Pick 2 more cards!", [card contents]];
                    }
                self.score -= FLIP_COST;
            }
            else {
                self.matchResult = [NSString stringWithFormat:@"%@ flipped down", [card contents]];
            }
            card.faceUp = !card.isFaceUp;
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
          usingGameMode:(NSInteger)gameMode{
    self = [super init];
    
    if (self) {
        self.gameMode = gameMode;
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
