//
//  BlocksBackgroundView.swift
//  BoomBlocks
//
//  Created by Pjcyber on 6/6/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import SwiftUI
import AVKit

struct BlocksBackgroundView: View {
    
    @ObservedObject var blocksViewModel = TetrisBlockViewModel()
    @State private var showingAlert = false
    @State private var player: AVAudioPlayer!
    var columns: Int { blocksViewModel.columns }
    var rows: Int { blocksViewModel.rows }
    //var menu = PauseMenu()
    
    var body: some View {
        ZStack {
            GeometryReader{(geometry: GeometryProxy) in
                self.drawBoard(boundingRect: geometry.size).shadow(color: .black, radius: 10, x: 0, y: 0)
                self.drawBoardWire(boundingRect: geometry.size)
                BlockBackgroundBorder()
                    .stroke(Color.lightBlue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            }
            
            Button(action: {
                self.blocksViewModel.onPause()
                self.showingAlert.toggle()
            }) {
                PauseButton()
            }.position(x:(UIScreen.main.bounds.width)/2, y: (UIScreen.main.bounds.height - (UIScreen.main.bounds.height * 0.05)))
            
            if (showingAlert) {
                PauseMenu()
            } else {
                PauseMenu().hidden()
            }
            //self.menu.hidden()
        }.onAppear{
            let url = Bundle.main.path(forResource: "imposible", ofType: "mp3")
            self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
            self.player.numberOfLoops = -1 
            self.player.play()
        }
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
        ).edgesIgnoringSafeArea(.all)
        
        
    }
    
    struct PauseButton : View {
        var body: some View {
           Image("pause").renderingMode(.original).resizable().frame(width: 50, height: 50)
        }
    }
    
    func drawBoard(boundingRect: CGSize) -> some View {
        let leftSpace = boundingRect.width * 0.30
        let rightSpace = boundingRect.width - leftSpace
        let topBottonSpace = (boundingRect.height - (rightSpace * 2))/2
        let blockSize = min(rightSpace/CGFloat(columns), (rightSpace*2)/CGFloat(rows))
        
        return ForEach(0...columns-1, id: \.self) { (column: Int) in
            ForEach(0...self.rows-1, id: \.self) { (row: Int) in
                Path {path in
                    let x = leftSpace/2  + blockSize*CGFloat(column)
                    let y = topBottonSpace + blockSize*CGFloat(row)
                    let rect = CGRect(x:  x, y: y, width: blockSize, height: blockSize)
                    path.addRect(rect)
                }
                .fill(self.blocksViewModel.blocksBoard[column][row].color)
                .gesture(self.blocksViewModel.getMoveGesture())
                .gesture(self.blocksViewModel.getRotateGesture())
             }
        }
    }
    
    func drawBoardWire(boundingRect: CGSize) -> some View {
        let columns = blocksViewModel.columns
        let rows = blocksViewModel.rows
        let leftSpace = boundingRect.width * 0.30
        let rightSpace = boundingRect.width - leftSpace
        let topBottonSpace = (boundingRect.height - (rightSpace * 2))/2
        let blockSize = min(rightSpace/CGFloat(columns), (rightSpace*2)/CGFloat(rows))
        
        return ForEach(0...columns-1, id: \.self) { (column: Int) in
            ForEach(0...rows-1, id: \.self) { (row: Int) in
                Path {path in
                    let x = leftSpace/2  + blockSize*CGFloat(column)
                    let y = topBottonSpace + blockSize*CGFloat(row)
                    let rect = CGRect(x:  x, y: y, width: blockSize, height: blockSize)
                    path.addRect(rect)
                }
                .stroke(Color.black, style: StrokeStyle(lineWidth: 1))
            }
        }
    }
}

struct BlockBackgroundBorder: Shape {
    func path(in boundingRect: CGRect) -> Path {
        let leftSpace = boundingRect.width * 0.30 // 30%
        let rightSpace = boundingRect.width - leftSpace
        let topBottonSpace = (boundingRect.height - rightSpace * 2)/2
        let minX = leftSpace/2 - 5
        let maxX = leftSpace/2 + rightSpace + 5
        let minY = topBottonSpace - 5
        let maxY = (topBottonSpace + rightSpace * 2) + 5
        
        var path = Path()
        path.move(to: CGPoint(x: minX, y: minY))
        path.addLine(to: CGPoint(x: minX, y: maxY))
        path.addLine(to: CGPoint(x: maxX, y: maxY))
        path.addLine(to: CGPoint(x: maxX, y: minY))
        path.addLine(to: CGPoint(x: minX, y: minY))
        return path
    }
}

struct PauseMenu : View {
    //@Binding var shown: Bool
    var body : some View{
        VStack(alignment: .center, spacing: 15) {
            Text("Pause").foregroundColor(.black).font(.largeTitle).bold()
            Button(action: {
                     }) {
                         HStack {
                            Image("reload").renderingMode(.original).resizable().frame(width: 80, height: 80)
                             
                        }
                }
            Button(action: {
               // self.shown.toggle()
            }) {
                HStack {
                    Image("start").renderingMode(.original).resizable().frame(width: 100, height: 50)
                }
            }
        }.padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}

#if DEBUG
struct BlocksBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BlocksBackgroundView()
    }
}
#endif
