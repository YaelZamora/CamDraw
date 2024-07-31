//
//  DrawingView.swift
//  CamDraw
//
//  Created by Yael Javier Zamora Moreno on 20/06/24.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @State var showTool: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Drawing(selected: showTool)
            }.ignoresSafeArea()
        }
    }
}

struct Drawing: UIViewRepresentable {
    @State var canvas = PKCanvasView()
    @State var tool = PKToolPicker()
    @State var selected: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        showPicker()
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

private extension Drawing {
    func showPicker() {
        // 1
        tool.setVisible(selected, forFirstResponder: canvas)
        // 2
        tool.addObserver(canvas)
        // 3
        canvas.becomeFirstResponder()
    }
}

#Preview {
    DrawingView(showTool: true)
}
