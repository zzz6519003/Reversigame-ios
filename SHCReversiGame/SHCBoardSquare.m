//
//  SHCBoardSquare.m
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/21/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCBoardSquare.h"

@implementation SHCBoardSquare
{
    int _row;
    int _column;
    SHCReversiBoard* _board;
    UIImageView* _blackView;
    UIImageView* _whiteView;
}


- (id)initWithFrame:(CGRect)frame column:(NSInteger)column row:(NSInteger)row board:(SHCReversiBoard *)board
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _row = row;
        _column = column;
        _board = board;
        
        // create the views for the playing piece graphics
        UIImage* blackImage = [UIImage imageNamed: @"ReversiBlackPiece.png"];
        _blackView = [[UIImageView alloc] initWithImage: blackImage];
        _blackView.alpha = 0.0;
        [self addSubview:_blackView];
        
        UIImage* whiteImage = [UIImage imageNamed: @"ReversiWhitePiece.png"];
        _whiteView = [[UIImageView alloc] initWithImage: whiteImage];
        _whiteView.alpha = 0.0;
        [self addSubview:_whiteView];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self update];
        [_board.boardDelegate addDelegate:self];    // This ensures that when each square is created, it is added to the multi-casting delegate; in this manner, all 64 squares will be informed of state changes. With this code in place, any change to the board state will be immediately reflected in the UI. This will come in handy very shortly.

    }
    return self;
}

- (void)update {
    BoardCellState state = [_board cellStateAtColumn:_column andRow:_row];
    _whiteView.alpha = state == BoardCellStateWhitePiece ? 1.0 : 0.0;
    _blackView.alpha = state == BoardCellStateBlackPiece ? 1.0 : 0.0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)cellStateChanged:(BoardCellState)state forColumn:(NSInteger)column andRow:(NSInteger)row {
    if ((column == _column && row == _row) || (column == -1 && row == -1)) {
        [self update];
    }
}

@end
