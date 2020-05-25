//
//  UIImage+GIF.swift
//  AaronSwift
//
//  Created by Aaron on 2020/5/25.
//

import UIKit

extension UIImage {
    
    public class func animatedImage(with source: CGImageSource) -> UIImage? {
        let count = source.animatedCount
        if count == 0 { return nil }
        if count == 1 { return source.image(at: 0) }
        #if os(iOS) || os(watchOS) || os(tvOS)
        var totalDuration: TimeInterval = 0
        var images: [UIImage] = []
        var frames: [(UIImage, UInt)] = []
        var durations: [UInt] = []
        for i in 0 ..< count {
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

extension CGImageSource {
    
    var animatedCount: Int {
        CGImageSourceGetCount(self)
    }
    
    func image(at index: Int) -> UIImage? {
        let downsampleOptions = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true] as CFDictionary
        guard let image = CGImageSourceCreateThumbnailAtIndex(self, index, downsampleOptions) else {
            return nil
        }
        let properties = (CGImageSourceCopyProperties(self, nil) as? [CFString: Any]) ?? [:]
        let exifOrientation = (properties[kCGImagePropertyOrientation] as? CGImagePropertyOrientation) ?? .up
        #if os(iOS) || os(watchOS) || os(tvOS)
        let orientation = exifOrientation.iOSOrientation
        return UIImage(cgImage: image, scale: 1.0, orientation: orientation)
        #else
        return UIImage(cgImage: image, scale: 1.0, orientation: exifOrientation)
        #endif
    }
    
    func duration(at index: Int) -> TimeInterval {
        var duration = 0.1
        guard let properties = CGImageSourceCopyProperties(self, nil) as? [CFString: Any] else {
            return duration
        }
        if let containerProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any] {
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
