//
//  MediaPickerDemo.swift
//  ImagePickerModule
//
//  Created by Cem Yilmaz on 20.08.21.
//

import AVKit
import SwiftUI

#if canImport(UIKit)
    public struct MediaPickerDemo: View {
        @State private var selectedImage: UIImage?
        @State private var selectedImages: [UIImage] = []
        @State private var selectedVideo: URL?
        @State private var selectedVideos: [URL] = []
        public var body: some View {
            List {
                Section(header: Text("Image Picker Button")) {
                    SingleMediaPickerButton(selectedImage: self.$selectedImage, selectedVideo: self.$selectedVideo) {
                        Text("no strategy")
                    }

                    SingleMediaPickerButton(selectedImage: self.$selectedImage, selectedVideo: self.$selectedVideo, noCameraAccessStrategy: .hideOption) {
                        Text("hideOption strategy")
                    }

                    SingleMediaPickerButton(selectedImage: self.$selectedImage, selectedVideo: self.$selectedVideo, noCameraAccessStrategy: .showToSettings) {
                        Text("showToSettings strategy")
                    }

                    SingleMediaPickerButton(
                        selectedImage: self.$selectedImage,
                        selectedVideo: self.$selectedVideo,
                        label: { Image(systemName: "photo") },
                        defaultImageContent: { Text("Default") }
                    )

                    SingleMediaPickerButton(
                        selectedImage: self.$selectedImage,
                        selectedVideo: self.$selectedVideo,
                        label: { Image(systemName: "photo") },
                        onDelete: {
                            print("on delete pressed")
                        },
                        defaultImageContent: { Text("on delete") }
                    )

                    SingleMediaPickerButton(selectedImage: self.$selectedImage,
                                            selectedVideo: self.$selectedVideo, label: { Text("allow editing") }, allowsEditing: true)
                }

                Section(header: Text("Images Picker Button")) {
                    MediasPickerButton(selectedImages: self.$selectedImages,
                                       selectedVideos: self.$selectedVideos,
                                       label: {
                                           Text("multiple medias")
                                       }, allowsEditing: false)

                    ScrollView(.horizontal) {
                        HStack {
                            if selectedVideos.count > 0 {
                                ForEach(selectedVideos, id: \.self) { video in
                                    VideoPlayer(player: AVPlayer(url: video))
                                        .frame(width: 200, height: 200)
                                        .padding()
                                        .cornerRadius(10.0)
                                        .onTapGesture {
                                            guard let index = self.selectedVideos.firstIndex(of: video) else { return }
                                            self.selectedVideos.remove(at: index)
                                        }
                                }
                            }
                            if selectedImages.count > 0 {
                                ForEach(selectedImages, id: \.self) { img in
                                    Image(uiImage: img)
                                        .resizable()
                                        .frame(width: 200, height: 200)
                                        .padding()
                                        .cornerRadius(10.0)
                                        .onTapGesture {
                                            guard let index = self.selectedImages.firstIndex(of: img) else { return }
                                            self.selectedImages.remove(at: index)
                                        }
                                }
                            }
                        }
                    }.padding(.vertical)
                }

            }.listStyle(GroupedListStyle())
        }
    }

    public struct ImagePicker_Previews: PreviewProvider {
        public static var previews: some View {
            MediaPickerDemo()
        }
    }
#endif
