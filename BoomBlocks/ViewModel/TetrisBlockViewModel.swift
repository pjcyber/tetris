//
//  BoomBlocks.swift
//  BoomBlocks
//
//  Created by Pjcyber on 6/7/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import SwiftUI
import Combine

class TetrisBlockViewModel: ObservableObject {
        
    @Published var blocksModel = TetrisBlockModel()
    
    var anyCancellable: AnyCancellable?
    var lastMoveLocation: CGPoint?
    var lastRotateAngle: Angle?
    var moveSides: Bool = true
    var moveUpDown: Bool = true
    var isPlaying: Bool = true
    var columns: Int { blocksModel.columns }
    var rows: Int { blocksModel.rows }
    
    var blocksBoard: [[BlockSquare]] {
        var board = blocksModel.gameBoard.map { $0.map(convertToBlockSquare)}
        
        if let tetronimo = blocksModel.tetromino {
            for blockLocation in tetronimo.blocks {
                board[blockLocation.column + tetronimo.origin.column][blockLocation.row + tetronimo.origin.row] = BlockSquare(color: getColor(blockType: tetronimo.blockType))
            }
        }

        return board
    }
    
    init() {
        anyCancellable = blocksModel.objectWillChange.sink {
            self.objectWillChange.send()
        }
    }
    
    func convertToBlockSquare(block: TetrisGameBlock?) -> BlockSquare{
        return BlockSquare(color: getColor(blockType: block?.blockType))
    }
    
    func getColor(blockType: BlockType?) -> Color {
        switch blockType {
        case .i:
            return .blue
        case .j:
            return .pink
        case .l:
            return .orange
        case .o:
            return .yellow
        case .s:
            return .green
        case .t:
            return .purple
        case .z:
            return .red
        case .none:
            return .darkBlue
        }
    }
    
    func getRotateGesture() -> some Gesture {
        let tap = TapGesture()
            .onEnded({self.blocksModel.rotateTetromino(clockwise: true)})
        
        let rotate = RotationGesture()
            .onChanged(onRotateChanged(value:))
            .onEnded(onRotateEnd(value:))
        
        return tap.simultaneously(with: rotate)
    }
    
    func onRotateChanged(value: RotationGesture.Value) {
        guard let start = lastRotateAngle else {
            lastRotateAngle = value
            return
        }
        
        let diff = value - start
        if diff.degrees > 10 {
            blocksModel.rotateTetromino(clockwise: true)
            lastRotateAngle = value
            return
        } else if diff.degrees < -10 {
            blocksModel.rotateTetromino(clockwise: false)
            lastRotateAngle = value
            return
        }
    }
    
    func onRotateEnd(value: RotationGesture.Value) {
        lastRotateAngle = nil
    }
    
    func getMoveGesture() -> some Gesture {
        return DragGesture()
        .onChanged(onMoveChanged(value:))
        .onEnded(onMoveEnded(_:))
    }
    
    func onMoveChanged(value: DragGesture.Value) {
        guard let start = lastMoveLocation else {
            lastMoveLocation = value.location
            return
        }
        
        let xDiff = value.location.x - start.x
        
        // Moving right
        if moveSides && xDiff > 10 {
            let _ = blocksModel.moveTetrominoRight()
            lastMoveLocation = value.location
            moveUpDown = false
            return
        }
        
        // Moving left
        if moveSides && xDiff < -10 {
            let _ = blocksModel.moveTetrominoLeft()
            lastMoveLocation = value.location
            moveUpDown = false
            return
        }
        
        let yDiff = value.location.y - start.y
        
        // Moving Down
        if moveUpDown && yDiff > 10 {
            let _ = blocksModel.moveTetrominoDown()
            lastMoveLocation = value.location
            moveSides = false
            return
        }
        
        // Dropping
        if moveUpDown && yDiff < -10 {
            blocksModel.dropTetromino()
            lastMoveLocation = value.location
            moveSides = false
            return
        }
    }
    
    func onMoveEnded(_: DragGesture.Value) {
        lastMoveLocation = nil
        moveSides = true
        moveUpDown = true
    }
    
    func onPause() {
        if isPlaying {
            blocksModel.pauseGame()
            isPlaying = false
        } else {
            blocksModel.resumeGame()
            isPlaying = true
        }
    }
}

struct BlockSquare {
    var color: Color
}
