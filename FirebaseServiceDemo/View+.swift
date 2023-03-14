//
//  View+.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 14.03.2023.
//

import SwiftUI
import PhotosUI

extension View {
    
#if os(iOS) || os(watchOS)
    /// Links a ``PhotosPicker`` selection to a ``UIImage`` binding
    /// - Parameters:
    ///   - selection: ``PhotosPicker`` selection
    ///   - selectedUIImage: ``UIImage`` binding
    @MainActor
    func linkPhotosPicker(selection: Binding<PhotosPickerItem?>, toSelectedUIImage selectedUIImage: Binding<UIImage?>) -> some View {
        self.onChange(of: selection.wrappedValue) { newValue in
            Task {
                if let imageData = try? await newValue?.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                    selectedUIImage.wrappedValue = image
                }
            }
        }
    }
#endif
}
