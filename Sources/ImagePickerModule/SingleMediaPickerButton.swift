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

        var selectPhotoOrVideoText: String
        var takePhotoOrVideoText: String
        var grantCameraAndMicrophoneText: String
        var showCurrentPhotoOrVideoText: String
        var deleteCurrentPhotoOrVideoText: String
        var grantCameraAndMicrophoneTextMessage: String
        var settingsText: String

        init(
            selectedImage: Binding<UIImage?>,
            selectedVideo: Binding<URL?>,
            noCameraAccessStrategy: NoPermissionsStrategy = NoPermissionsStrategy.showToSettings,
            label: @escaping () -> Content,
            onDelete: (() -> Void)? = nil,
            defaultImageContent: (() -> DefaultImageContent)?,
            allowsEditing: Bool = false,
            selectPhotoOrVideoText: String = "Selezionare la foto o il video dalla libreria",
            takePhotoOrVideoText: String = "Scattare una foto o video con la fotocamera",
            showCurrentPhotoOrVideoText: String = "Mostra l'immagine o video corrente",
            deleteCurrentPhotoOrVideoText: String = "Rimuovere l'immagine o video corrente",
            grantCameraAndMicrophoneText: String = "È necessario l'accesso alla telecamera e al microfono",
            grantCameraAndMicrophoneTextMessage: String = "L'accesso alla fotocamera e al microfono può essere concesso nelle impostazioni di sistema di questa applicazione.",
            settingsText: String = "Impostazioni"
        ) {
            _selectedImage = selectedImage
            _selectedVideo = selectedVideo
            self.noCameraAccessStrategy = noCameraAccessStrategy
            self.onDelete = onDelete
            self.label = label()
            self.defaultImageContent = defaultImageContent
            self.allowsEditing = allowsEditing
            self.selectPhotoOrVideoText = selectPhotoOrVideoText
            self.takePhotoOrVideoText = takePhotoOrVideoText
            self.showCurrentPhotoOrVideoText = showCurrentPhotoOrVideoText
            self.deleteCurrentPhotoOrVideoText = deleteCurrentPhotoOrVideoText
            self.grantCameraAndMicrophoneText = grantCameraAndMicrophoneText
            self.grantCameraAndMicrophoneTextMessage = grantCameraAndMicrophoneTextMessage
            self.settingsText = settingsText
        }

        public var body: some View {
            ZStack {
                Menu(
                    content: {
                        Button(
                            action: { self.showLibraryMediaPicker = true },
                            label: {
                                Label(self.selectPhotoOrVideoText, systemImage: "folder")
                            }
                        )

                        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized ||
                            AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined
                        {
                            Button(
                                action: { self.showCameraMediaPicker = true },
                                label: {
                                    Label(self.takePhotoOrVideoText, systemImage: "camera")
                                }
                            )

                        } else if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
                            if self.noCameraAccessStrategy == NoPermissionsStrategy.showToSettings {
                                Button(
                                    action: {
                                        self.showCameraAndMicrophoneAccessRequiredAlert = true
                                    },
                                    label: {
                                        Label(self.takePhotoOrVideoText, systemImage: "camera")
                                    }
                                )
                            }
                        }

                        if self.defaultImageContent != nil || self.selectedImage != nil || self.selectedVideo != nil {
                            Button(
                                action: { self.showSelectedImageOrVideo = true },
                                label: {
                                    Label(self.showCurrentPhotoOrVideoText, systemImage: "arrow.up.backward.and.arrow.down.forward")
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
                                    Label(self.deleteCurrentPhotoOrVideoText,
                                          systemImage: "xmark")
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
                        title: Text(self.grantCameraAndMicrophoneText),
                        message: Text(self.grantCameraAndMicrophoneTextMessage),
                        primaryButton: Alert.Button.default(Text(self.settingsText)) {
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
