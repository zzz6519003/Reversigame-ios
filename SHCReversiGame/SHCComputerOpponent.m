//
//  SHCComputerOpponent.m
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/26/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCComputerOpponent.h"

@implementation SHCComputerOpponent 
{
    SHCReversiBoard* _board;
    BoardCellState _computerColor;
}

- (id)initWithBoard:(SHCReversiBoard *)board andColor:(BoardCellState)computerColor {
    if (self = [super init]) {
        _board = board;
        _computerColor = computerColor;
        // listen to game state changes in order to know when to make a move
        [_board.reversiBoardDelegate addDelegate:self];
    }
    return self;
}

// The gameStateChanged method checks whether it is the computer’s turn, and if so, pauses for one second before making a move. The reason for this pause is purely cosmetic — it just makes it appear that the computer is thinking! It’s the little things like this that really add “polish” to your app.

- (void)gameStateChanged {
    if (_board.nextMove == _computerColor) {
        // pause 1 second, then make a move
        [self performSelector:@selector(makeNextMove) withObject:nil afterDelay:1.0];
        
    }
}

// The makeNextMove method is a bit more complex. It iterates through each cell in the board to find all valid moves. When it finds a valid move, it clones the board using the NSCopying protocol that was added earlier and tries out the move and determines the resulting score. In this manner, the computer player will be able to look-ahead at every possible next move and evaluate the outcome.
- (void)makeNextMove {
    NSInteger bestScore = NSIntegerMin;
    NSInteger bestRow, bestColumn;;
    
    // check every possible move, then select the one with the best 'score'
    for (NSInteger row = 0; row < 8; row++)
    {
        for (NSInteger col = 0; col < 8; col++)
        {
            if ([_board isValidMoveToColumn:col andRow:row])
            {
                // clone the current board
                SHCReversiBoard *testBoard = [_board copyWithZone:nil];
                // make this move
                [testBoard makeMoveToColumn:col andRow:row];
                // compute the score - i.e. the difference in black and white score
                int score = _computerColor == BoardCellStateWhitePiece ? testBoard.whiteScore - testBoard.blackScore : testBoard.blackScore - testBoard.whiteScore;
                if (score > bestScore) {
                    bestScore = score;
                    bestRow = row;
                    bestColumn = col;
                }
            }
        }
    }
    if (bestScore > NSIntegerMin)
    {
        [_board makeMoveToColumn:bestColumn andRow:bestRow];
    }

}

@end
