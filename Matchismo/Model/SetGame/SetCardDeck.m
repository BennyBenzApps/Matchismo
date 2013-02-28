//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Benjamin Lavin on 2013-02-28.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck
- (id)init {
    self = [super init];
    if (self) {
        for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++) {
            for(NSString *symbol in [SetCard validSymbols]){
                for (NSString *color in [SetCard validColors]) {
                    for (NSString *shading in [SetCard validShadings]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.color = color;
                        card.shading = shading;
                    [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}
@end
