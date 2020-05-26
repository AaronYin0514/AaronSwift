//
//  UIImage+GIF.swift
//  AaronSwift
//
//  Created by Aaron on 2020/5/25.
//

import UIKit

extension UIImage {
    
    public class func animatedImage(with data: Data, scale: CGFloat = 1.0) -> UIImage? {
        guard let source = ImageSource(data) else { return nil }
        if source.count == 0 { return nil }
        if source.count == 1 { return source.image(at: 0) }
        #if os(iOS) || os(watchOS) || os(tvOS)
        var totalDuration: TimeInterval = 0
        var images: [UIImage] = []
        var frames: [(UIImage, UInt)] = []
        var durations: [UInt] = []
        for i in 0 ..< source.count {
            guard let image = source.image(at: i) else {
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
    
    #if os(iOS) || os(watchOS) || os(tvOS)
    public let orientation: UIImage.Orientation
    #else
    public let orientation: CGImagePropertyOrientation
    #endif
    
    public let pixelSize: CGSize
    
    public let uttype: CFString?
    
    public init(_ source: CGImageSource) {
        self.source = source
        count = CGImageSourceGetCount(source)
        let properties = (CGImageSourceCopyProperties(source, nil) as? [CFString: Any]) ?? [:]
        let exifOrientation = (properties[kCGImagePropertyOrientation] as? CGImagePropertyOrientation) ?? .up
        #if os(iOS) || os(watchOS) || os(tvOS)
        orientation = exifOrientation.iOSOrientation
        #else
        orientation = exifOrientation
        #endif
        let pixelWidth = (properties[kCGImagePropertyPixelWidth] as? Int) ?? 0
        let pixelHeight = (properties[kCGImagePropertyPixelHeight] as? Int) ?? 0
        pixelSize = CGSize(width: pixelWidth, height: pixelHeight)
        uttype = CGImageSourceGetType(source)
    }
    
    public init?(_ data: Data) {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        self.init(source)
    }
    
    func image(at index: Int, options: CFDictionary? = nil) -> UIImage? {
        guard let image = CGImageSourceCreateImageAtIndex(source, index, options) else { return nil }
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
