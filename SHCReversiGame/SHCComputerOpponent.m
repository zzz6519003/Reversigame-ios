//
//  SHCComputerOpponent.m
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/26/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCComputerOpponent.h"
typedef struct
{
    NSInteger column;
    NSInteger row;
} Move;
//This will make it easier to pass moves between methods.


@implementation SHCComputerOpponent 
{
    SHCReversiBoard* _board;
    BoardCellState _computerColor;
    NSInteger _maxDepth;
}

- (id)initWithBoard:(SHCReversiBoard *)board andColor:(BoardCellState)computerColor maxDepth:(NSInteger)depth {
    if (self = [super init]) {
        _board = board;
        _computerColor = computerColor;
        _maxDepth = depth;
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
//    NSInteger bestScore = NSIntegerMin;
//    NSInteger bestRow, bestColumn;;
//    
//    // check every possible move, then select the one with the best 'score'
//    for (NSInteger row = 0; row < 8; row++)
//    {
//        for (NSInteger col = 0; col < 8; col++)
//        {
//            if ([_board isValidMoveToColumn:col andRow:row])
//            {
//                // clone the current board
//                SHCReversiBoard *testBoard = [_board copyWithZone:nil];
//                // make this move
//                [testBoard makeMoveToColumn:col andRow:row];
//                // compute the score - i.e. the difference in black and white score
//                int score = _computerColor == BoardCellStateWhitePiece ? testBoard.whiteScore - testBoard.blackScore : testBoard.blackScore - testBoard.whiteScore;
//                if (score > bestScore) {
//                    bestScore = score;
//                    bestRow = row;
//                    bestColumn = col;
//                }
//            }
//        }
//    }
//    if (bestScore > NSIntegerMin)
//    {
//        [_board makeMoveToColumn:bestColumn andRow:bestRow];
//    }
    Move bestMove = {.column = -1, .row =  -1};
    NSInteger bestScore = NSIntegerMin;
    // check every valid move for this particular board, then select the one with the best 'score'
    NSArray* moves = [self validMovesForBoard:_board];
    for(NSValue* moveValue in moves) {
        Move nextMove;
        [moveValue getValue:&nextMove];
        // clone the current board and make this move
        SHCReversiBoard *testBoard = [_board copyWithZone:nil];
        [testBoard makeMoveToColumn:nextMove.column andRow:nextMove.row];
        [testBoard makeMoveToColumn:nextMove.column andRow:nextMove.row];
        // determine the score for this move
        NSInteger scoreForMove = [self scoreForBoard:testBoard depth:1];
        // pick the best
        if (scoreForMove > bestScore || bestScore == NSIntegerMin)
        {
            bestScore = scoreForMove;
            bestMove.row = nextMove.row;
            bestMove.column = nextMove.column;
        }


    }
    
    if (bestMove.column != -1 && bestMove.row != -1)
    {
        [_board makeMoveToColumn:bestMove.column andRow:bestMove.row];
    }

}

// Computes the score for the given board
- (NSInteger)scoreForBoard:(SHCReversiBoard*)board depth:(NSInteger)depth {
    // if we have reached the maximum search depth, then just compute the
    // score of the current board state
    if (depth >= _maxDepth)
    {
        return _computerColor == BoardCellStateWhitePiece ?
        board.whiteScore - board.blackScore :
        board.blackScore - board.whiteScore;
    }
    
    NSInteger minMax = NSIntegerMin;
    
    // check every valid next move for this particular board
    NSArray* moves = [self validMovesForBoard:board];
    for (NSValue *moveValue in moves) {
        // Extract the Move struct from the NSValue box
        Move nextMove;
        [moveValue getValue:&nextMove];

        // clone the current board and make the move
        SHCReversiBoard* testBoard = [_board copyWithZone:nil];
        [testBoard makeMoveToColumn:nextMove.column andRow:nextMove.row];
        // compute the score for this board with a recursive call
        NSInteger score = [self scoreForBoard:testBoard depth:depth + 1];
        
        // wtf is this...
        // pick the best score
        if (depth % 2 == 0)
        {
            if (score > minMax || minMax == NSIntegerMin)
            {
                minMax = score;
            }
        }
        else
        {
            if (score < minMax || minMax == NSIntegerMin)
            {
                minMax = score;
            }
        }

    }
    return minMax;
}



// returns an array of valid next moves for the given board
- (NSArray *)validMovesForBoard:(SHCReversiBoard *)board {
    NSMutableArray *moves = [[NSMutableArray alloc] init];
    
    for (NSUInteger row = 0; row < 8; row++) {
        for (NSUInteger col = 0; col < 8; col++) {
            if ([board isValidMoveToColumn:col andRow:row]) {
                Move move = {.column = col, .row = row};
                [moves addObject:[NSValue valueWithBytes:&move objCType:@encode(Move)]];
            }
        }
    }
    return moves;
    //This method returns an array of all the possible next moves for the given board state. Notice that because Move is a struct, it needs to be boxed within an NSValue object since NSArrays and NSMutableArrays can only store objects.

}

@end
