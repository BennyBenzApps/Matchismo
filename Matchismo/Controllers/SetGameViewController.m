//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Benjamin Lavin on 2013-02-28.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "GameResult.h"

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) NSMutableArray *actionsHistory;

@end

@implementation SetGameViewController

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    return _gameResult;
}

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[SetCardDeck alloc] init]
                                              usingGameMode:1];
    }
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self.actionsHistory addObject:self.game.matchResult];
    [self updateUI];
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}
- (IBAction)scrollHistory:(UISlider *)sender {
    sender.alpha = (sender.value == sender.maximumValue) ? 1.0 : 0.5;
    self.resultsLabel.text = [self.actionsHistory objectAtIndex:floor(sender.value)];
}

- (NSMutableArray *) actionsHistory
{
    if (!_actionsHistory) _actionsHistory = [[NSMutableArray alloc] init];
    return _actionsHistory;
}

- (void) updateLastHistoryAction {
    [self.actionsHistory addObject:self.game.matchResult];
    self.historySlider.maximumValue = self.actionsHistory.count-1;
    [self.historySlider setValue: self.historySlider.maximumValue animated:YES];
    self.historySlider.alpha = 1.0;
}

- (IBAction)flipCard:(UIButton *)sender {
    if (! self.historySlider.enabled){
        self.historySlider.enabled = YES;
    }
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateLastHistoryAction];
    [self updateUI];
    self.gameResult.score = self.game.score;
}

- (IBAction)newGame {
    self.game = nil;
    self.gameResult = nil;
    self.historySlider.maximumValue = 0;
    [self.historySlider setValue:0];
    self.historySlider.enabled = NO;
    self.actionsHistory = nil;
    self.flipCount = 0;
    self.game.matchResult = @"Set card game! Pick a card!";
    [self updateLastHistoryAction];
    [self updateUI];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"cardfront.jpg"] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"cardfront.jpg"] forState:UIControlStateSelected];
        [cardButton setBackgroundImage:[UIImage imageNamed:@"cardback.jpg"] forState:UIControlStateSelected|UIControlStateDisabled];

        //[cardButton setImageEdgeInsets:UIEdgeInsetsMake(1, 2, 2, 2)];
        [cardButton setAttributedTitle:[self getAttributedStringContentsForCard:(SetCard *)card] forState:UIControlStateNormal];
        //[cardButton setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#>
        //[cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultsLabel.text = self.game.matchResult;
}

- (NSAttributedString *)getAttributedStringContentsForCard:(SetCard *)card{
    UIColor *color = [[UIColor alloc] init];
    NSNumber *width = @1;
    
    if ([card.color isEqualToString:@"red"]) {
        color = [UIColor redColor];
    }
    else if ([card.color isEqualToString:@"green"]) {
        color = [UIColor greenColor];
    }
    else if ([card.color isEqualToString:@"purple"]) {
        color = [UIColor purpleColor];
    }
    UIColor *strokeColor = color;
    if ([card.shading isEqualToString:@"solid"]){
        width = (NSNumber *)@-5;
    }
    else if ([card.shading isEqualToString:@"striped"]){
        color = [color colorWithAlphaComponent:0.2];
        width = (NSNumber *)@-5;
    }
    else if ([card.shading isEqualToString:@"open"]){
        width = (NSNumber *)@5;
    }
    NSAttributedString *contents = [[NSAttributedString alloc] initWithString:card.contents attributes:@{NSForegroundColorAttributeName:color,NSStrokeWidthAttributeName:width,NSStrokeColorAttributeName:strokeColor}];
    return contents;
    
}

@end
