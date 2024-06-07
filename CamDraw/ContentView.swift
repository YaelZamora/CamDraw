//
//  ContentView.swift
//  CamDraw
//
//  Created by Yael Javier Zamora Moreno on 06/06/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        ZStack {
            ARViewContainer().edgesIgnoringSafeArea(.all)
            
            image?
                .resizable()
                .opacity(0.5)
            
            Button("", systemImage: "camera.fill") {
                showingImagePicker.toggle()
            }.position(x: 30, y: 30)
        }
        .onChange(of: showingImagePicker) { _ in loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
