//
//  ImagePicker.swift
//  target
//
//  Created by Sávio Dutra on 11/02/24.
//

import SwiftUI
#if !os(macOS)

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
#else
import AppKit

struct ImagePicker: View {
    @Binding var selectedImage: NSImage
    
    var body: some View {
        Button("Selecionar Imagem") {
            let panel = NSOpenPanel()
            panel.allowedFileTypes = ["png", "jpg", "jpeg"]
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            
            if panel.runModal() == .OK,
               let url = panel.url,
               let nsImage = NSImage(contentsOf: url) {
                selectedImage = nsImage
            }
        }
            
    }
}
#endif
