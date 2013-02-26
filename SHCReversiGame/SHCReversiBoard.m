//
//  SHCReversiBoard.m
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/21/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCReversiBoard.h"
#import "SHCReversiBoardDelegate.h"


// A 'navigation' function. This takes the given row / column values and navigates in one of the 8 possible directions across the playing board.
//typedef void (^BoardNavigationFunction)(NSInteger*, NSInteger*);
typedef void(^BoardNavigationFunction)(NSInteger*, NSInteger*);

BoardNavigationFunction BoardNavigationFunctionRight = ^(NSInteger *c, NSInteger *r) {
    (*c)++;
};
BoardNavigationFunction BoardNavigationFunctionLeft = ^(NSInteger* c, NSInteger* r) {
    (*c)--;
};

BoardNavigationFunction BoardNavigationFunctionUp = ^(NSInteger* c, NSInteger* r) {
    (*r)--;
};

BoardNavigationFunction BoardNavigationFunctionDown = ^(NSInteger* c, NSInteger* r) {
    (*r)++;
};

BoardNavigationFunction BoardNavigationFunctionRightUp = ^(NSInteger* c, NSInteger* r) {
    (*c)++;
    (*r)--;
};

BoardNavigationFunction BoardNavigationFunctionRightDown = ^(NSInteger* c, NSInteger* r) {
    (*c)++;
    (*r)++;
};
BoardNavigationFunction BoardNavigationFunctionLeftUp = ^(NSInteger* c, NSInteger* r) {
    (*c)--;
    (*r)++;
};

BoardNavigationFunction BoardNavigationFunctionLeftDown = ^(NSInteger* c, NSInteger* r) {
    (*c)--;
    (*r)--;
};
/*The above code typedefs a block, BoardNavigationFunction, which takes as its arguments pointers to two integers. It is then followed by eight blocks, each of which de-reference the two arguments and either increment or decrement them. It looks a little strange, to be sure, but you’ll soon see what this is all about.
*/


@implementation SHCReversiBoard {
    BoardNavigationFunction _boardNavigationFunctions[8];
    id<SHCReversiBoardDelegate> _delegate;
}

- (id)init {
    if (self = [super init]) {
        [self commonInit];
        [self setToInitialState];
    }
    return self;
}

- (void)commonInit {
    _boardNavigationFunctions[0] = BoardNavigationFunctionUp;
    _boardNavigationFunctions[1] = BoardNavigationFunctionDown;
    _boardNavigationFunctions[2] = BoardNavigationFunctionLeft;
    _boardNavigationFunctions[3] = BoardNavigationFunctionRight;
    _boardNavigationFunctions[4] = BoardNavigationFunctionLeftDown;
    _boardNavigationFunctions[5] = BoardNavigationFunctionLeftUp;
    _boardNavigationFunctions[6] = BoardNavigationFunctionRightDown;
    _boardNavigationFunctions[7] = BoardNavigationFunctionRightUp;
    
    _reversiBoardDelegate = [[SHCMulticastDelegate alloc] init];
    _delegate = (id)_reversiBoardDelegate;
    
}

- (void)setToInitialState
{
    // clear the board
    [super clearBoard];
    
    // add initial play counters
    [super setCellState:BoardCellStateWhitePiece forColumn:3 andRow:3];
    [super setCellState:BoardCellStateBlackPiece forColumn:4 andRow:3];
    [super setCellState:BoardCellStateBlackPiece forColumn:3 andRow:4];
    [super setCellState:BoardCellStateWhitePiece forColumn:4 andRow:4];
    
    _whiteScore = 2;
    _blackScore = 2;
    
    // Black gets the first turn
    _nextMove = BoardCellStateBlackPiece;
    
}

- (BOOL)isValidMoveToColumn:(NSInteger)column andRow:(NSInteger)row {
    // check empty
//    if ([super cellStateAtColumn:column andRow:row] != BoardCellStateEmpty) {
//        return NO;
//    }
//    return YES;
    
    return [self isValidMoveToColumn:column andRow:row forState:self.nextMove];

}
- (BOOL)isValidMoveToColumn:(int)column andRow:(int)row forState:(BoardCellState)state {
    if ([super cellStateAtColumn:column andRow:row] != BoardCellStateEmpty)
        return NO;
    // check each direction
    for(int i=0;i<8;i++)
    {
        if ([self moveSurroundsCountersForColumn:column
                                          andRow:row
                          withNavigationFunction:_boardNavigationFunctions[i]
                                         toState:state])
        {
            return YES;
        }
    }
    
    // if no directions are valid - then this is not a valid move
    return NO;

}
// The above code uses the array of navigation functions to check each in turn to see if any of the opponent’s pieces are surrounded. Note that this method has been split into two parts – one which has a state argument, and the other that uses the nextMove property. You’ll see the reason for this shortly.


- (void)makeMoveToColumn:(NSInteger)column andRow:(NSInteger)row {
    // place the playing piece at the given location
    [self setCellState:self.nextMove forColumn:column andRow:row];
    for (int i = 0; i < 8; i++) {
        [self flipOponnentsCountersForColumn:column andRow:row withNavigationFunction:_boardNavigationFunctions[i] toState:self.nextMove];
    }
//    _nextMove = [self invertState];
    [self switchTurns];
    
    _gameHasFinished = [self hasGameFinished];
    _whiteScore = [self countCellsWithState:BoardCellStateWhitePiece];
    _blackScore = [self countCellsWithState:BoardCellStateBlackPiece];

    if ([_delegate respondsToSelector:@selector(gameStateChanged)]) {
        [_delegate gameStateChanged];
    }
}

- (BoardCellState)invertState {
    BoardCellState a;
    if (self.nextMove == BoardCellStateWhitePiece) {
        a = BoardCellStateBlackPiece;
    }
    if (self.nextMove == BoardCellStateBlackPiece) {
        a = BoardCellStateWhitePiece;
    }
    return a;
}

- (BoardCellState)invertStateAndReturn:(BoardCellState)a {
    if (a == BoardCellStateBlackPiece) {
        return BoardCellStateWhitePiece;
    }
    return BoardCellStateBlackPiece;
}

- (BOOL)moveSurroundsCountersForColumn:(NSInteger)column andRow:(NSInteger)row withNavigationFunction:(BoardNavigationFunction) navigationFunction toState:(BoardCellState)state {
    // This method determines whether a move to a specific location on the board would surround one or more of the opponent’s pieces. This method uses the supplied navigationFunction to move from one cell to the next. Notice that because the row and column are integers, which are passed by value, the ampersand (&) operator is used to pass a pointer to the integer, allowing its value to be changed by the navigation block.
    
    NSInteger index = 1;
    // advance to the next cell
    navigationFunction(&column, &row);
    
    // while within the bounds of the board
    // Within the while loop, the required conditions are checked: the neighbouring cell must be occupied by a piece of the opposing colour, and following cells can be either the opposing colour (in which case the while loop continues), or the player’s colour – which means that a group has been surrounded.
    while(column>=0 && column<=7 && row>=0 && row<=7) {
        BoardCellState currentCellState = [super cellStateAtColumn:column andRow:row];
        // the cell that is the immediate neighbour must be of the other colour
        if (index == 1) {
            if (currentCellState != [self invertStateAndReturn:state]) {
                return NO;
            }
        } else {            // if we have reached a cell of the same colour, this is a valid move
            if (currentCellState == state) {
                return YES;
            }            // if we have reached an empty cell - fail
            if (currentCellState == BoardCellStateEmpty) {
                return NO;
            }
        
        }
        index++;
        
        // advance to the next cell
        navigationFunction(&column, &row);
    }
    return NO;
}

- (void)flipOponnentsCountersForColumn:(int) column andRow:(int)row withNavigationFunction:(BoardNavigationFunction) navigationFunction toState:(BoardCellState) state {
    // are any pieces surrounded in this direction?
    if (![self moveSurroundsCountersForColumn:column andRow:row withNavigationFunction:navigationFunction toState:state]) {
        return;
    }
    BoardCellState opponentsState = [self invertStateAndReturn:state];
    BoardCellState currentCellState;
    // flip counters until the edge of the boards is reached, or
    // a piece of the current state is reached
    do {
        navigationFunction(&column, &row);
        currentCellState = [super cellStateAtColumn:column andRow:row];
        [self setCellState:state forColumn:column andRow:row];
    } while ((column <= 7 && column >= 0) && (row <= 7 && row >= 0) && currentCellState == opponentsState);
}

- (BOOL)hasGameFinished {
    return ![self canPlayerMakeAMove:BoardCellStateBlackPiece] && ![self canPlayerMakeAMove:BoardCellStateWhitePiece];
}

- (BOOL)canPlayerMakeAMove:(BoardCellState)state {
    for (int row = 0; row < 8; row++)
    {
        for (int col = 0; col < 8; col++)
        {
            if ([self isValidMoveToColumn:col andRow:row forState:state]) {
                return YES;
            }
        }
    }
    return NO;
}

// The last rule to implement is that if one player cannot make a move, play switches back to the opponent.
- (void)switchTurns {
    BoardCellState nextOne = [self invertStateAndReturn:self.nextMove];
    if ([self canPlayerMakeAMove:nextOne]) {
        _nextMove = nextOne;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    SHCReversiBoard *board = [super copyWithZone:zone];
    board ->_nextMove = _nextMove;
    board ->_whiteScore = _whiteScore;
    board ->_blackScore = _blackScore;
    return board;
}

@end
