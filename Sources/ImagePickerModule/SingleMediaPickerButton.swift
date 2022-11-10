//
//  SingleMediaPickerButton.swift
//  ImagePickerModule
//
//  Created by Cem Yilmaz on 20.08.21.
//

import AVFoundation
import AVKit
import SwiftUI

#if canImport(UIKit)
    public struct SingleMediaPickerButton<Content: View, DefaultImageContent: View>: View {
        public enum NoPermissionsStrategy {
            case hideOption, showToSettings
        }

        private let noCameraAccessStrategy: NoPermissionsStrategy

        @Binding private var selectedImage: UIImage?
        @Binding private var selectedVideo: URL?
        public private(set) var allowsEditing: Bool

        private let label: Content

        private let onDelete: (() -> Void)?
        private let defaultImageContent: (() -> DefaultImageContent)?

        @State private var showCameraMediaPicker: Bool = false
        @State private var showLibraryMediaPicker: Bool = false
        @State private var showSelectedImageOrVideo: Bool = false
        @State private var showCameraAndMicrophoneAccessRequiredAlert: Bool = false

        init(
            selectedImage: Binding<UIImage?>,
            selectedVideo: Binding<URL?>,
            noCameraAccessStrategy: NoPermissionsStrategy = NoPermissionsStrategy.showToSettings,
            label: @escaping () -> Content,
            onDelete: (() -> Void)? = nil,
            defaultImageContent: (() -> DefaultImageContent)?,
            allowsEditing: Bool = false
        ) {
            _selectedImage = selectedImage
            _selectedVideo = selectedVideo
            self.noCameraAccessStrategy = noCameraAccessStrategy
            self.onDelete = onDelete
            self.label = label()
            self.defaultImageContent = defaultImageContent
            self.allowsEditing = allowsEditing
        }

        public var body: some View {
            ZStack {
                Menu(
                    content: {
                        Button(
                            action: { self.showLibraryMediaPicker = true },
                            label: {
                                Label(NSLocalizedString("Selezionare la foto o video dalla libreria", comment: ""),
                                      systemImage: "folder")
                            }
                        )

                        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized ||
                            AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined
                        {
                            Button(
                                action: { self.showCameraMediaPicker = true },
                                label: {
                                    Label(NSLocalizedString("Scattare una foto o video con la fotocamera", comment: ""),
                                          systemImage: "camera")
                                }
                            )

                        } else if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
                            if self.noCameraAccessStrategy == NoPermissionsStrategy.showToSettings {
                                Button(
                                    action: {
                                        self.showCameraAndMicrophoneAccessRequiredAlert = true
                                    },
                                    label: {
                                        Label(
                                            NSLocalizedString("Scattare una foto o video con la fotocamera", comment: ""),
                                            systemImage: "camera"
                                        )
                                    }
                                )
                            }
                        }

                        if self.defaultImageContent != nil || self.selectedImage != nil || self.selectedVideo != nil {
                            Button(
                                action: { self.showSelectedImageOrVideo = true },
                                label: {
                                    Label(
                                        NSLocalizedString("Mostra l'immagine o video corrente", comment: ""),
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
                                    self.selectedVideo = nil
                                },
                                label: {
                                    Label(
                                        NSLocalizedString("Rimuovere l'immagine o video corrente", comment: ""),
                                        systemImage: "xmark"
                                    )
                                }
                            )
                        }

                    },

                    label: {
                        if let defaultImageContent = self.defaultImageContent,
                           self.selectedImage == nil || self.selectedVideo == nil
                        {
                            defaultImageContent()
                        } else {
                            self.label
                        }
                    }

                ).textCase(nil)

                Text("").sheet(isPresented: self.$showCameraMediaPicker) {
                    MediaPicker(sourceType: .camera, onImagePicked: { image in
                        self.selectedImage = image
                    }, onVideoPicked: { video in
                        self.selectedVideo = video
                    }, allowsEditing: allowsEditing)
                        .ignoresSafeArea()
                }

                Text("").sheet(isPresented: self.$showLibraryMediaPicker) {
                    MediaPicker(sourceType: .photoLibrary,
                                onImagePicked: { image in
                                    self.selectedImage = image
                                }, onVideoPicked: { video in
                                    self.selectedVideo = video
                                }, allowsEditing: allowsEditing)
                        .ignoresSafeArea()
                }

                Text("").sheet(isPresented: self.$showSelectedImageOrVideo) {
                    if let defaultImageContent = self.defaultImageContent {
                        defaultImageContent()

                    } else if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    } else if let selectedVideo {
                        VideoPlayer(player: AVPlayer(url: selectedVideo))
                    }
                }

                Text("").alert(isPresented: self.$showCameraAndMicrophoneAccessRequiredAlert) {
                    Alert(
                        title: Text(NSLocalizedString("È necessario l'accesso alla telecamera", comment: "")),
                        message: Text(NSLocalizedString("L'accesso alla fotocamera può essere concesso nelle impostazioni di sistema di questa applicazione.", comment: "")),
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

    public extension SingleMediaPickerButton where DefaultImageContent == EmptyView {
        init(
            selectedImage: Binding<UIImage?>,
            selectedVideo: Binding<URL?>,
            noCameraAccessStrategy: NoPermissionsStrategy = NoPermissionsStrategy.showToSettings,
            label: @escaping () -> Content,
            onDelete: (() -> Void)? = nil,
            allowsEditing: Bool = false
        ) {
            self.init(
                selectedImage: selectedImage,
                selectedVideo: selectedVideo,
                noCameraAccessStrategy: noCameraAccessStrategy,
                label: label,
                onDelete: onDelete,
                defaultImageContent: nil,
                allowsEditing: allowsEditing
            )
        }
    }
#endif
