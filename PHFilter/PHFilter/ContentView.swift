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
    
    @State private var filterIntensity = 0.5
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
                Slider(value: $filterIntensity, in: 0.01...1)
                    .onChange(of: filterIntensity) { _ in
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
        
        imageSaver.successHandler = {
            toast = FancyToast(type: .success, title: "Success", message: "Saving succeed")
        }
        
        imageSaver.errorHandler = {
            debugPrint($0)
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: inputImage!.size.width / 2, y: inputImage!.size.height / 2), forKey: kCIInputCenterKey)
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
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
