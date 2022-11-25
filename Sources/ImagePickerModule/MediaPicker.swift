//
//  MediaPicker.swift
//  ImagePickerModule
//
//  Created by Cem Yilmaz on 20.08.21.
//

import SwiftUI

#if canImport(UIKit)
    public struct MediaPicker: UIViewControllerRepresentable {
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void
        private let onVideoPicked: (URL) -> Void
        // if true, the user can edit its selected media, but he is not allowed to select more than once
        // default init is false
        private let allowsEditing: Bool
        @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

        public init(sourceType: UIImagePickerController.SourceType,
                    onImagePicked: @escaping (UIImage) -> Void,
                    onVideoPicked: @escaping (URL) -> Void,
                    allowsEditing: Bool = false)
        {
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
            self.onVideoPicked = onVideoPicked
            self.allowsEditing = allowsEditing
        }

        public func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            // both photos and videos
            picker.mediaTypes = ["public.image", "public.movie"]
            picker.delegate = context.coordinator
            picker.allowsEditing = allowsEditing
            return picker
        }

        public func updateUIViewController(_: UIImagePickerController, context _: Context) {}

        public func makeCoordinator() -> Coordinator {
            Coordinator(
                onDismiss: { self.presentationMode.wrappedValue.dismiss() },
                onImagePicked: onImagePicked,
                onVideoPicked: onVideoPicked,
                allowsEditing: allowsEditing
            )
        }

        public final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            private let onDismiss: () -> Void
            private let onImagePicked: (UIImage) -> Void
            private let onVideoPicked: (URL) -> Void
            private let allowsEditing: Bool

            init(onDismiss: @escaping () -> Void,
                 onImagePicked: @escaping (UIImage) -> Void,
                 onVideoPicked: @escaping (URL) -> Void,
                 allowsEditing: Bool)
            {
                self.onDismiss = onDismiss
                self.onImagePicked = onImagePicked
                self.onVideoPicked = onVideoPicked
                self.allowsEditing = allowsEditing
            }

            public func imagePickerController(
                _: UIImagePickerController,
                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
            ) {
                if let image = info[allowsEditing ? .editedImage : .originalImage] as? UIImage {
                    onImagePicked(image)
                }
                if let videoURl = info[.mediaURL] as? URL {
                    onVideoPicked(videoURl)
                }
                onDismiss()
            }

            public func imagePickerControllerDidCancel(_: UIImagePickerController) {
                onDismiss()
            }
        }
    }
#endif
