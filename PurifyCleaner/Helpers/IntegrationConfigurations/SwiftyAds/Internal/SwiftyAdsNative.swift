//    The MIT License (MIT)
//
//    Copyright (c) 2015-2022 Dominik Ringler
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import GoogleMobileAds

protocol SwiftyAdsNativeType: AnyObject {
    func load(from viewController: UIViewController,
              adUnitIdType: SwiftyAdsAdUnitIdType,
              loaderOptions: SwiftyAdsNativeAdLoaderOptions,
              adTypes: [GADAdLoaderAdType],
              onFinishLoading: (() -> Void)?,
              onError: ((Error) -> Void)?,
              onReceive: @escaping (GADNativeAd) -> Void)
    func stopLoading()
}

final class SwiftyAdsNative: NSObject {

    // MARK: - Properties

    private let environment: SwiftyAdsEnvironment
    private let adUnitId: String
    private let request: () -> GADRequest

    private var onFinishLoading: (() -> Void)?
    private var onError: ((Error) -> Void)?
    private var onReceive: ((GADNativeAd) -> Void)?
    
    private var adLoader: GADAdLoader?
    
    // MARK: - Initialization

    init(environment: SwiftyAdsEnvironment, adUnitId: String, request: @escaping () -> GADRequest) {
        self.environment = environment
        self.adUnitId = adUnitId
        self.request = request
    }
}

// MARK: - SwiftyAdsNativeType

extension SwiftyAdsNative: SwiftyAdsNativeType {
    func load(from viewController: UIViewController,
              adUnitIdType: SwiftyAdsAdUnitIdType,
              loaderOptions: SwiftyAdsNativeAdLoaderOptions,
              adTypes: [GADAdLoaderAdType],
              onFinishLoading: (() -> Void)?,
              onError: ((Error) -> Void)?,
              onReceive: @escaping (GADNativeAd) -> Void) {
        self.onFinishLoading = onFinishLoading
        self.onError = onError
        self.onReceive = onReceive

        // If AdLoader is already loading we should not make another request
        if let adLoader = adLoader, adLoader.isLoading { return }

        // Create multiple ads ad loader options
        var multipleAdsAdLoaderOptions: [GADMultipleAdsAdLoaderOptions]? {
            switch loaderOptions {
            case .single:
                return nil
            case .multiple(let numberOfAds):
                let options = GADMultipleAdsAdLoaderOptions()
                options.numberOfAds = numberOfAds
                return [options]
            }
        }

        // Set the ad unit id
        var adUnitId: String {
            if case .development = environment {
                return self.adUnitId
            }
            switch adUnitIdType {
            case .plist:
                return self.adUnitId
            case .custom(let id):
                return id
            }
        }

        // Create GADAdLoader
        adLoader = GADAdLoader(
            adUnitID: adUnitId,
            rootViewController: viewController,
            adTypes: adTypes,
            options: multipleAdsAdLoaderOptions
        )

        // Set the GADAdLoader delegate
        adLoader?.delegate = self

        // Load ad with request
        adLoader?.load(request())
    }

    func stopLoading() {
        adLoader?.delegate = nil
        adLoader = nil
    }
}

// MARK: - GADNativeAdLoaderDelegate

extension SwiftyAdsNative: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        onReceive?(nativeAd)
    }

    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        onFinishLoading?()
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        onError?(error)
    }
}
