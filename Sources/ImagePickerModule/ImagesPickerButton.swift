//
//  ImagesPickerButton.swift
//  ImagePickerModule
//
//  Created by Cem Yilmaz on 20.08.21.
//

import SwiftUI
import AVFoundation

#if canImport(UIKit)
public struct ImagesPickerButton<Content: View>: View {

    public enum NoCameraAccessStrategy {
        case hideOption, showToSettings
    }

    @Binding public var selectedImages: [UIImage]
    private let noCameraAccessStrategy: NoCameraAccessStrategy
    public let label: Content

    @State private var showCameraImagePicker: Bool = false
    @State private var showLibraryImagePicker: Bool = false
    @State private var showCameraAccessRequiredAlert: Bool = false

    public init(
        selectedImages: Binding<[UIImage]>,
        noCameraAccessStrategy: NoCameraAccessStrategy = NoCameraAccessStrategy.showToSettings,
        @ViewBuilder label: @escaping () -> Content
    ) {
        self._selectedImages = selectedImages
        self.noCameraAccessStrategy = noCameraAccessStrategy
        self.label = label()
    }

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
                                label: { Label(NSLocalizedString("Foto mit Kamera aufnehmen", comment: ""), systemImage: "camera") }
                            )
                        }

                    }

                },

                label: { self.label }

            ).textCase(nil)

            Text("").sheet(isPresented: self.$showCameraImagePicker) {
                ImagePicker(sourceType: UIImagePickerController.SourceType.camera) { image in
                    self.selectedImages.append(image)
                }.ignoresSafeArea()
            }

            Text("").sheet(isPresented: self.$showLibraryImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    self.selectedImages.append(image)
                }.ignoresSafeArea()
            }

            Text("").alert(isPresented: self.$showCameraAccessRequiredAlert) {
                Alert(
                    title: Text(NSLocalizedString("Kamerazugriff benötigt", comment: "")),
                    message: Text(NSLocalizedString("Der Kamerazugriff kann in den Systemeinstellungen für diese App gewährt werden.", comment: "")),
                    primaryButton: Alert.Button.default(Text(NSLocalizedString("Einstellungen", comment: ""))) {
                        guard let settingsULR = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(settingsULR, options: [:], completionHandler: nil)
                    },
                    secondaryButton: Alert.Button.cancel()
                )
            }

        }

    }

}
#endif
