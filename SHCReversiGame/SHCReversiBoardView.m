//
//  SHCReversiBoardView.m
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/21/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCReversiBoardView.h"
#import "SHCBoardSquare.h"


@implementation SHCReversiBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame andBoard:(SHCReversiBoard *)board
{
    if (self = [super initWithFrame:frame])
    {
        float rowHeight = frame.size.height / 8.0;
        float columnWidth = frame.size.width / 8.0;
        
        // create the 8x8 cells for this board
        for (int row = 0; row < 8; row++)
        {
            for (int col = 0; col < 8; col++)
            {
                SHCBoardSquare* square = [[SHCBoardSquare alloc] initWithFrame:CGRectMake(col*columnWidth, row*rowHeight, columnWidth, rowHeight) column:col row:row board:board];
                [self addSubview:square];
            }
        }
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
