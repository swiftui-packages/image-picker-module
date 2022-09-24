//
//  ImagePickerModuleDemo.swift
//  ImagePickerModule
//
//  Created by Cem Yilmaz on 20.08.21.
//

import SwiftUI

#if canImport(UIKit)
public struct ImagePickerDemo: View {

    @State private var selectedImage: UIImage?
    @State private var selectedImages: [UIImage] = []

    public var body: some View {

        List {

            Section(header: Text("Regular Image Picker")) {
                // ImagePicker(sourceType: .camera, onImagePicked: { image in })
                // ImagePicker(sourceType: .photoLibrary, onImagePicked: { image in })
                // ImagePicker(sourceType: .savedPhotosAlbum, onImagePicked: { image in })
            }

//            if let selectedImage = self.selectedImage {
//
//                Section {
//
//                    Image(uiImage: selectedImage)
//                        .resizable()
//                        .scaledToFit()
//
//                }
//
//            }

            Section(header: Text("Image Picker Button")) {
                ImagePickerButton(selectedImage: self.$selectedImage) {
                    Image(systemName: "photo")
                }

                ImagePickerButton(selectedImage: self.$selectedImage, noCameraAccessStrategy: .hideOption) {
                    Image(systemName: "photo")
                }

                ImagePickerButton(selectedImage: self.$selectedImage, noCameraAccessStrategy: .showToSettings) {
                    Image(systemName: "photo")
                }

                ImagePickerButton(
                    selectedImage: self.$selectedImage,
                    label: { Image(systemName: "photo") },
                    defaultImageContent: nil != nil ? nil : { Text("Default") }
                )

                ImagePickerButton(
                    selectedImage: self.$selectedImage,
                    label: { Image(systemName: "photo") },
                    onDelete: {},
                    defaultImageContent: { Image(systemName: "photo") }
                )

                ImagePickerButton(
                    selectedImage: self.$selectedImage,
                    noCameraAccessStrategy: .hideOption,
                    label: { Image(systemName: "photo") },
                    onDelete: {},
                    defaultImageContent: { Image(systemName: "photo") }
                )
            }

            Section(header: Text("Images Picker Button")) {
                ImagesPickerButton(selectedImages: self.$selectedImages) {
                    Image(systemName: "plus")
                }

                ScrollView(.horizontal) {
                    HStack {
                        ForEach(self.selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 48, height: 48)
                                .cornerRadius(8)
                        }
                    }
                }.padding(.vertical)

                // ImagesPickerButton(
                //     selectedImages: <#T##Binding<[UIImage]>#>,
                //     noCameraAccessStrategy: <#T##NoCameraAccessStrategy#>,
                //     label: <#T##() -> _#>
                // )
            }

        }.listStyle(GroupedListStyle())

    }

}

public struct ImagePicker_Previews: PreviewProvider {

    public static var previews: some View {

        ImagePickerDemo()

    }

}
#endif
