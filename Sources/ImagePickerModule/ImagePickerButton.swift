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

    private let noCameraAccessStrategy: NoCameraAccessStrategy

    @Binding private var selectedImage: UIImage?
    private let label: Content

    private let onDelete: (() -> Void)?
    private let defaultImageContent: (() -> DefaultImageContent)?

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
                            Label(NSLocalizedString("Foto aus Bibliothek auswählen", comment: ""), systemImage: "folder")
                        }
                    )

                    if AVCaptureDevice.authorizationStatus(for: .video) == .authorized ||
                        AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {

                        Button(
                            action: { self.showCameraImagePicker = true },
                            label: { Label(NSLocalizedString("Foto mit Kamera aufnehmen", comment: ""), systemImage: "camera") }
                        )

                    } else if AVCaptureDevice.authorizationStatus(for: .video) == .denied {

                        if self.noCameraAccessStrategy == NoCameraAccessStrategy.showToSettings {
                            Button(
                                action: { self.showCameraAccessRequiredAlert = true },
                                label: {
                                    Label(
                                        NSLocalizedString("Foto mit Kamera aufnehmen", comment: ""),
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
                                    NSLocalizedString("Aktuelles Bild anzeigen", comment: ""),
                                    systemImage: "arrow.up.backward.and.arrow.down.forward"
                                )
                            }
                        )

                    }

                    if let onDelete = self.onDelete {

                        Button(
                            action: {
                                onDelete()
                                self.selectedImage = nil
                            },
                            label: {
                                Label(
                                    NSLocalizedString("Aktuelles Bild entfernen", comment: ""),
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
                    title: Text(NSLocalizedString("Kamerazugriff benötigt", comment: "")),
                    message: Text(NSLocalizedString("Der Kamerazugriff kann in den Systemeinstellungen für diese App gewährt werden.", comment: "")),
                    primaryButton: Alert.Button.default(Text(NSLocalizedString("Einstellungen", comment: ""))) {
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    },
                    secondaryButton: Alert.Button.cancel()
                )
            }

        }

    }

}



extension ImagePickerButton {

    public init(
        selectedImage: Binding<UIImage?>,
        noCameraAccessStrategy: NoCameraAccessStrategy = NoCameraAccessStrategy.showToSettings,
        label: @escaping () -> Content,
        onDelete: (() -> Void)? = nil,
        defaultImageContent: (() -> DefaultImageContent)?
    ) {
        self._selectedImage = selectedImage
        self.noCameraAccessStrategy = noCameraAccessStrategy
        self.onDelete = onDelete
        self.label = label()
        self.defaultImageContent = defaultImageContent
    }

}



extension ImagePickerButton where DefaultImageContent == EmptyView {

    public init(
        selectedImage: Binding<UIImage?>,
        noCameraAccessStrategy: NoCameraAccessStrategy = NoCameraAccessStrategy.showToSettings,
        label: @escaping () -> Content,
        onDelete: (() -> Void)? = nil
    ) {
        self.init(
            selectedImage: selectedImage,
            noCameraAccessStrategy: noCameraAccessStrategy,
            label: label,
            onDelete: onDelete,
            defaultImageContent: nil
        )
    }

}
#endif
