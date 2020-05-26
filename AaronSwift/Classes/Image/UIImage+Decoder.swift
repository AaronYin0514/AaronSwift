//
//  UIImage+GIF.swift
//  AaronSwift
//
//  Created by Aaron on 2020/5/25.
//

import UIKit

extension UIImage {
    
    public class func animatedImage(with data: Data, scale: CGFloat = 1.0, preserveAspectRatio ratio: Bool = true, thumbnailPixelSize size: CGSize = .zero) -> UIImage? {
        guard let source = ImageSource(data) else { return nil }
        if source.count == 0 { return nil }
        if source.count == 1 { return source.image(at: 0) }
        #if os(iOS) || os(watchOS) || os(tvOS)
        var totalDuration: TimeInterval = 0
        var images: [UIImage] = []
        var frames: [(UIImage, UInt)] = []
        var durations: [UInt] = []
        for i in 0 ..< source.count {
            guard let image = source.image(at: i, scale: scale, preserveAspectRatio: ratio, thumbnailPixelSize: size) else {
                continue
            }
            let duration = source.duration(at: i) * 1000
            durations.append(UInt(duration))
            totalDuration += duration
            frames.append((image, UInt(duration)))
        }
        let gcd = gcdEuclidean(durations)
        if gcd == 0 {
            images = frames.flatMap { [$0.0] }
        } else {
            images = frames.flatMap { (frame) -> [UIImage] in
                let repeatCount = Int(frame.1 / gcd)
                return Array(repeating: frame.0, count: repeatCount)
            }
        }
        return UIImage.animatedImage(with: images, duration: totalDuration / 1000)
        #else
        return nil
        #endif
    }
    
}

public struct ImageSource {
    
    public let source: CGImageSource
    
    public let count: Int
    
    public init(_ source: CGImageSource) {
        self.source = source
        count = CGImageSourceGetCount(source)
    }
    
    public init?(_ data: Data) {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        self.init(source)
    }
    
    func image(at index: Int, scale: CGFloat = 1.0, preserveAspectRatio ratio: Bool = true, thumbnailPixelSize size: CGSize = .zero, options: CFDictionary? = nil) -> UIImage? {
        let properties = CGImageSourceCopyPropertiesAtIndex(source, index, options) as? [CFString: Any] ?? [:]
        let exifOrientation = (properties[kCGImagePropertyOrientation] as? CGImagePropertyOrientation) ?? .up
        #if os(iOS) || os(watchOS) || os(tvOS)
        let orientation = exifOrientation.iOSOrientation
        #else
        let orientation = exifOrientation
        #endif
        let pixelWidth = (properties[kCGImagePropertyPixelWidth] as? CGFloat) ?? 0.0
        let pixelHeight = (properties[kCGImagePropertyPixelHeight] as? CGFloat) ?? 0.0
//        let uttype = CGImageSourceGetType(source)
        var cgImage: CGImage?
        var decodingOptions = options as? [CFString: Any] ?? [:]
        if pixelWidth == 0 || pixelHeight == 0 || size.width == 0 || size.height == 0 || (pixelWidth <= size.width && pixelHeight <= size.height) {
            cgImage = CGImageSourceCreateImageAtIndex(source, index, decodingOptions as CFDictionary)
        } else {
            decodingOptions[kCGImageSourceCreateThumbnailWithTransform] = ratio
            var maxPixelSize: CGFloat = 0.0
            if ratio {
                let pixelRatio = pixelWidth / pixelHeight
                let thumbnailRatio = size.width / size.height;
                maxPixelSize = pixelRatio > thumbnailRatio ? size.width : size.height
            } else {
                maxPixelSize = max(size.width, size.height)
            }
            decodingOptions[kCGImageSourceThumbnailMaxPixelSize] = maxPixelSize
            decodingOptions[kCGImageSourceCreateThumbnailFromImageIfAbsent] = true
            cgImage = CGImageSourceCreateThumbnailAtIndex(source, index, decodingOptions as CFDictionary)
        }
        guard let image = cgImage else { return nil }
        return UIImage(cgImage: image, scale: 1.0, orientation: orientation)
    }
    
    func duration(at index: Int) -> TimeInterval {
        let options = [
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceShouldCache: true
        ] as CFDictionary
        var duration = 0.1
        guard let p = CGImageSourceCopyPropertiesAtIndex(source, index, options) as? [CFString: Any] else {
            return duration
        }
        if let containerProperties = p[kCGImagePropertyGIFDictionary] as? [CFString: Any] {
            if let delayTimeUnclampedProp = containerProperties[kCGImagePropertyGIFUnclampedDelayTime] as? TimeInterval {
                duration = delayTimeUnclampedProp
            } else {
                if let delayTimeProp = containerProperties[kCGImagePropertyGIFDelayTime] as? TimeInterval {
                    duration = delayTimeProp
                }
            }
        }
        if (duration < 0.011) { duration = 0.1 }
        return duration
    }
    
}
