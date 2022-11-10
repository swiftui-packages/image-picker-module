//
//  ImagesPickerButton.swift
//  ImagePickerModule
//
//  Created by Cem Yilmaz on 20.08.21.
//

import AVFoundation
import SwiftUI

#if canImport(UIKit)
    public struct MediasPickerButton<Content: View>: View {
        public enum NoPermissionsStrategy {
            case hideOption, showToSettings
        }

        @Binding public var selectedImages: [UIImage]
        @Binding public var selectedVideos: [URL]
        public private(set) var allowsEditing: Bool
        private let noCameraAccessStrategy: NoPermissionsStrategy
        public let label: Content

        @State private var showCameraMediaPicker: Bool = false
        @State private var showLibraryMediaPicker: Bool = false
        @State private var showMicrophoneAndCameraAccessRequiredAlert: Bool = false

        public init(
            selectedImages: Binding<[UIImage]>,
            selectedVideos: Binding<[URL]>,
            noCameraAccessStrategy: NoPermissionsStrategy = NoPermissionsStrategy.showToSettings,
            @ViewBuilder label: @escaping () -> Content,
            allowsEditing: Bool = false
        ) {
            _selectedImages = selectedImages
            _selectedVideos = selectedVideos
            self.noCameraAccessStrategy = noCameraAccessStrategy
            self.label = label()
            self.allowsEditing = allowsEditing
        }

        public var body: some View {
            ZStack {
                Menu(
                    content: {
                        Button(
                            action: { self.showLibraryMediaPicker = true },
                            label: {
                                Label(NSLocalizedString("Selezionare le foto o i video dalla libreria", comment: ""),
                                      systemImage: "folder")
                            }
                        )

                        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized ||
                            AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined
                        {
                            Button(
                                action: { self.showCameraMediaPicker = true },
                                label: {
                                    Label(NSLocalizedString("Scattare una foto o registrare un video con la fotocamera", comment: ""),
                                          systemImage: "camera")
                                }
                            )

                        } else if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
                            if self.noCameraAccessStrategy == NoPermissionsStrategy.showToSettings {
                                Button(
                                    action: { self.showMicrophoneAndCameraAccessRequiredAlert = true
                                    },
                                    label: {
                                        Label(NSLocalizedString("Scattare una foto o registrare un video con la fotocamera", comment: ""),
                                              systemImage: "camera")
                                    }
                                )
                            }
                        }

                    },

                    label: { self.label }

                ).textCase(nil)

                Text("").sheet(isPresented: self.$showCameraMediaPicker) {
                    MediaPicker(sourceType: .camera,
                                onImagePicked: { image in
                                    self.selectedImages.append(image)
                                }, onVideoPicked: { video in
                                    self.selectedVideos.append(video)
                                }, allowsEditing: allowsEditing).ignoresSafeArea()
                }

                Text("").sheet(isPresented: self.$showLibraryMediaPicker) {
                    MediaPicker(sourceType: .photoLibrary,
                                onImagePicked: { image in
                                    self.selectedImages.append(image)
                                }, onVideoPicked: { video in
                                    self.selectedVideos.append(video)
                                }, allowsEditing: allowsEditing)
                }

                Text("").alert(isPresented: self.$showMicrophoneAndCameraAccessRequiredAlert) {
                    Alert(
                        title: Text(NSLocalizedString("È necessario l'accesso alla telecamera e al microfono", comment: "")),
                        message: Text(NSLocalizedString("L'accesso alla fotocamera e al microfono può essere concesso nelle impostazioni di sistema di questa applicazione.", comment: "")),
                        primaryButton: Alert.Button.default(Text(NSLocalizedString("Impostazioni", comment: ""))) {
                            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        },
                        secondaryButton: Alert.Button.cancel()
                    )
                }
            }
        }
    }
#endif
