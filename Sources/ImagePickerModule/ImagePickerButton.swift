//
//  ImagePickerButton.swift
//  ImagePickerModule
//
//  Created by Cem Yilmaz on 20.08.21.
//

import SwiftUI
import AVFoundation

#if canImport(UIKit)
public struct ImagePickerButton<Content: View, DefaultImageContent: View>: View {

    public enum NoCameraAccessStrategy {
        case hideOption, showToSettings
    }

    public init(
        selectedImage: Binding<UIImage?>,
        noCameraAccessStrategy: NoCameraAccessStrategy = NoCameraAccessStrategy.showToSettings,
        onDelete: @escaping (() -> Void) = {},
        label: @escaping () -> Content,
        defaultImageContent: (() -> DefaultImageContent)?
    ) {
        self._selectedImage = selectedImage
        self.noCameraAccessStrategy = noCameraAccessStrategy
        self.onDelete = onDelete
        self.label = label()
        self.defaultImageContent = defaultImageContent
    }

    private let noCameraAccessStrategy: NoCameraAccessStrategy

    @Binding public var selectedImage: UIImage?
    public let label: Content

    public let onDelete: () -> Void
    public let defaultImageContent: (() -> DefaultImageContent)?

    @State private var showCameraImagePicker: Bool = false
    @State private var showLibraryImagePicker: Bool = false
    @State private var showSelectedImage: Bool = false
    @State private var showCameraAccessRequiredAlert: Bool = false

    public var body: some View {

        ZStack {

            Menu(

                content: {

                    Button(
                        action: { self.showLibraryImagePicker = true },
                        label: {
                            Label("Foto aus Bibliothek auswählen", systemImage: "folder")
                        }
                    )

                    if AVCaptureDevice.authorizationStatus(for: .video) == .authorized ||
                        AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {

                        Button(
                            action: { self.showCameraImagePicker = true },
                            label: { Label("Foto mit Kamera aufnehmen", systemImage: "camera") }
                        )

                    } else if AVCaptureDevice.authorizationStatus(for: .video) == .denied {

                        if self.noCameraAccessStrategy == NoCameraAccessStrategy.showToSettings {
                            Button(
                                action: { self.showCameraAccessRequiredAlert = true },
                                label: {
                                    Label(
                                        "Foto mit Kamera aufnehmen",
                                        systemImage: "camera"
                                    )
                                }
                            )
                        }

                    }

                    if self.defaultImageContent != nil || self.selectedImage != nil {

                        Button(
                            action: { self.showSelectedImage = true },
                            label: {
                                Label(
                                    "Aktuelles Bild anzeigen",
                                    systemImage: "arrow.up.backward.and.arrow.down.forward"
                                )
                            }
                        )

                        Button(
                            action: {
                                self.onDelete()
                                self.selectedImage = nil
                            },
                            label: {
                                Label(
                                    "Aktuelles Bild entfernen",
                                    systemImage: "xmark"
                                )
                            }
                        )
                    }

                },

                label: {

                    if let defaultImageContent = self.defaultImageContent, self.selectedImage == nil {
                        defaultImageContent()
                    } else {
                        self.label
                    }

                }

            ).textCase(nil)

            Text("").sheet(isPresented: self.$showCameraImagePicker) {

                ImagePicker(sourceType: UIImagePickerController.SourceType.camera) { image in
                    self.selectedImage = image
                }.ignoresSafeArea()

            }

            Text("").sheet(isPresented: self.$showLibraryImagePicker) {

                ImagePicker(sourceType: .photoLibrary) { image in
                    self.selectedImage = image
                }.ignoresSafeArea()

            }

            Text("").sheet(isPresented: self.$showSelectedImage) {

                if let defaultImageContent = self.defaultImageContent {

                    defaultImageContent()

                } else if let profilePicture = self.selectedImage {

                    Image(uiImage: profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)

                }

            }

            Text("").alert(isPresented: self.$showCameraAccessRequiredAlert) {
                Alert(
                    title: Text("Kamerazugriff benötigt"),
                    message: Text("Der Kamerazugriff kann in den Systemeinstellungen für diese App gewährt werden."),
                    primaryButton: Alert.Button.default(Text("Einstellungen")) {
                        guard let settingsULR = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(settingsULR, options: [:], completionHandler: nil)
                    },
                    secondaryButton: Alert.Button.cancel()
                )
            }

        }

    }

}

extension ImagePickerButton where DefaultImageContent == EmptyView {

    public init(
        selectedImage: Binding<UIImage?>,
        noCameraAccessStrategy: NoCameraAccessStrategy = NoCameraAccessStrategy.showToSettings,
        @ViewBuilder label: @escaping () -> Content,
        onDelete: @escaping (() -> Void) = {}
    ) {
        self.init(
            selectedImage: selectedImage,
            noCameraAccessStrategy: noCameraAccessStrategy,
            onDelete: onDelete,
            label: label,
            defaultImageContent: nil
        )
    }

}
#endif
