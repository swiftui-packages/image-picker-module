# Image Picker Module
[![build](https://github.com/swiftui-packages/image-picker-module/actions/workflows/build.yml/badge.svg)](https://github.com/swiftui-packages/image-picker-module/actions/workflows/build.yml)
[![test](https://github.com/swiftui-packages/image-picker-module/actions/workflows/test.yml/badge.svg)](https://github.com/swiftui-packages/image-picker-module/actions/workflows/test.yml)
[![swiftlint](https://github.com/swiftui-packages/image-picker-module/actions/workflows/swiftlint.yml/badge.svg)](https://github.com/swiftui-packages/image-picker-module/actions/workflows/swiftlint.yml)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/d62a7ab525064c0d9a8a9f5a667b2506)](https://www.codacy.com/gh/swiftui-packages/image-picker-module/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=swiftui-packages/image-picker-module&amp;utm_campaign=Badge_Grade)
[![swiftpackageindex swift versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswiftui-packages%2Fimage-picker-module%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/swiftui-packages/image-picker-module)
[![swiftpackageindex platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswiftui-packages%2Fimage-picker-module%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/swiftui-packages/image-picker-module)

## Usage
You have 3 options to make use of the Image Picker Module in your SwiftUI project:

1.  Use plain MediaPicker which has the parameters source type and a completion function, which returns the selected picture or taken photo/video
2.  Use the SingleMediaPickerButton which takes a binding of an optional UIImage and URL and lets you define a label for the button.
    The Button itself comes with some functionality, which will be expanded in the future. 
    For example does it detect if a photo/video was taken and shows you the option to remove it or show it in full screen.
3.  Use the MediasPickerButton, which is supposed to expand image/video collections and there for takes a UIImage Array Binding/ URL Array Binding and again lets you set its label.

<br>

## Integration
1.  Copy the resource url:
```
https://github.com/Kuama-IT/image-picker-module.git
```

2.  Open your Xcode project

3.  Two options a and b for step 3<br>
    a) &nbsp; At the menu bar navigate to _File_ / _Swift Packages_ / _Add Package Dependency_<br>
    b1)  Select the project's root folder<br>
    b2)  select your app name under _PROJECT_<br>
    b3)  Open _Swift Packages_ tab on the right side of _Info_ and _Build Settings_<br>
    b4)  Hit the _+_ button at the bottom of the list<br>

4.  Here you should be prompted to "_Choose Package Repository:_"

5.  Paste the resource url

6.  Select _Next_ to go with the latest version or select a specific version or branch

7.  After a short loading period of package resolution you get prompted to _Choose package products and targets_ (the default should be fine)

8.  The complete hit the _Finish_ button

9.  Import ImagePickerModule into the files where you want to use it

<br>

## required info.plist entries
- _Privacy - Camera Usage Description_
- _Privacy - Microphone Usage Description_

<br>

## Can also be found here
-   [Swift Package Registry](https://swiftpackageregistry.com/swiftui-packages/image-picker-module)
-   [Swift Package Index](https://swiftpackageindex.com/swiftui-packages/image-picker-module)
-   [Swift Pack](https://swiftpack.co/package/swiftui-packages/image-picker-module)

<br>

## ToDos
-   maintaining README.md file
    -   GIF of importing Swift Package Manager Packages into Xcode Projects
    -   phrasing an introduction text
    -   writing usage instructions with code examples
