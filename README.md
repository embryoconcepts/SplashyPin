# SplashyPin - WIP

A project comparing UI methods using Unsplash with a Pinterest-style collection view: storyboard, programmatic, and SwiftUI.

<img src="SplashyPin-storyboard.gif" alt="SplashyPin-storyboard" width="250" />

### Note: 
If you choose to download and run locally, you will need to provide an API key for Unsplash. 

Generate an Unsplash API key here: https://unsplash.com/developers

To run on your own machine, you can either:
1) replace the `kUnsplashAPIKey` in `UnsplashClient`:12 with your own key OR
2) if you want to keep your key private, create an `APIKeys.swift` file, with one line: `let let kUnsplashAPIKey = "YOUR KEY HERE"` and add the file name to your `.gitignore` file

