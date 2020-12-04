import Foundation

class UnsplashClient: APIClient {
    static let baseUrl = "https://api.unsplash.com"
    // Generate an Unsplash API key here: https://unsplash.com/developers
    // To run on your own machine, you can either:
    // 1) replace the `kUnsplashAPIKey` below with your own key OR
    // 2) if you want to keep your key private, create an `APIKeys.swift` file, with one line:
    // `let let kUnsplashAPIKey = "YOUR KEY HERE"`
    // and add the file name to your `.gitignore` file

    static let apiKey = kUnsplashAPIKey

    func fetch(with endpoint: UnsplashEndpoint, completion: @escaping (Result<Photos>) -> Void) {
        let request = endpoint.request
        get(with: request, completion: completion)
    }
}
