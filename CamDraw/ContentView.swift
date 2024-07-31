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
    @State private var showGuides = true
    @State private var recording = false
    @State private var inputImage: UIImage?
    @State private var opacity = 0.5
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    let columns = [
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80))
    ]
    
    @StateObject private var recorder = Recorder()
    
    var body: some View {
        NavigationView {
            ZStack {
                CameraPreview(session: $recorder.session).ignoresSafeArea()
                
                image?
                    .resizable()
                    .opacity(opacity)
                    .scaleEffect(currentZoom + totalZoom)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                currentZoom = value.magnitude - 1
                            }
                            .onEnded { value in
                                totalZoom += currentZoom
                                currentZoom = 0
                            }
                    )
                
                if showGuides {
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(0..<24) { item in
                            ZStack {
                                //
                            }.frame(width: 90, height: 90).overlay(
                                RoundedRectangle(cornerRadius: 0).stroke(.black.opacity(0.5))
                            )
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    Slider(value: $opacity, in: 0...1)
                }
            }
            .onChange(of: showingImagePicker) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .toolbar {
                HStack {
                    NavigationLink {
                        DrawingView(showTool: true)
                    } label: {
                        Image(systemName: "pencil")
                    }
                    Button("", systemImage: "camera.fill") {
                        showingImagePicker.toggle()
                    }
                    
                    Button("", systemImage: "square.grid.3x3") {
                        showGuides.toggle()
                    }
                    
                    if recording {
                        Button("", systemImage: "record.circle.fill") {
                            recording.toggle()
                            
                            recorder.stopRecording()
                        }
                    } else {
                        Button("", systemImage: "record.circle") {
                            recording.toggle()
                            
                            recorder.startRecording()
                        }
                    }
                }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

#Preview {
    ContentView()
}
