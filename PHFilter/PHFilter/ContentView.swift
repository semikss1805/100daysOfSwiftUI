//
//  ContentView.swift
//  PHFilter
//
//  Created by SemikSS on 19.01.2023.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

extension View {
    func toastView(toast: Binding<FancyToast?>) -> some View {
        self.modifier(FancyToastModifier(toast: toast))
    }
}

struct ContentView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var showingImagePicker = false
    
    @State private var filterIntesity = 0.5
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    private let context = CIContext()
    
    @State private var showingFilterSheet = false
    
    @State private var toast: FancyToast? = nil
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("Tap to select image")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                image?
                    .resizable()
                    .scaledToFit()
            }
            .onTapGesture {
                showingImagePicker = true
            }
            
            HStack {
                Text("Intensity")
                Slider(value: $filterIntesity)
                    .onChange(of: filterIntesity) { _ in
                        applyProcessing()
                    }
            }
            
            HStack {
                Button("Change Filter") {
                    showingFilterSheet = true
                }
                
                Spacer()
                
                if image != nil {
                    Button("Save") {
                        saveImage()
                    }
                }
                
            }
        }
        .padding()
        .padding(.top, 32)
        .onChange(of: inputImage) { _ in loadImage() }
        .toastView(toast: $toast)
        .sheet(isPresented: $showingImagePicker, onDismiss: { showingImagePicker = false }) {
            ImagePicker(image: $inputImage)
        }
        .confirmationDialog("Select Filter", isPresented: $showingFilterSheet) {
            Button("Crystallize") { setFilter(.crystallize()) }
            Button("Bloom") { setFilter(.bloom()) }
            Button("Gaussian  Blur") { setFilter(.gaussianBlur()) }
            Button("Pixellate") { setFilter(.pixellate()) }
            Button("Sepia Tone") { setFilter(.sepiaTone()) }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func saveImage() {
        guard let processedImage = processedImage else { return }

        let imageSaver = ImageSaver()
        
        imageSaver.succesHandler = {
            toast = FancyToast(type: .success, title: "Success", message: "Saving succeed")
        }
        
        imageSaver.errorHandler = {
            debugPrint($0)
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func applyProcessing() {
        let inputKays = currentFilter.inputKeys
        
        if inputKays.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntesity, forKey: kCIInputIntensityKey)
        }
        if inputKays.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntesity * 200, forKey: kCIInputRadiusKey)
        }
        if inputKays.contains(kCIInputScaleKey ) {
            currentFilter.setValue(filterIntesity * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
         
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
