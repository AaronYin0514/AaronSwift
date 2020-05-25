//
//  Decoder.swift
//  AaronSwift
//
//  Created by Aaron on 2020/5/15.
//

import Foundation

public protocol Decoder {
    
    associatedtype Base
    
    func decodable(_ data: Data) -> Bool
    
    func decode(_ data: Data) -> Base?
    
}

public struct ImageDecoder: Decoder {
    
    public typealias Base = UIImage
    
    public init() {}
    
    public func decodable(_ data: Data) -> Bool {
        let format = data.imageFormat
        switch format {
        case .webP, .gif:
            return false
        case .heic:
            return UIImage.heicDecodable
        default:
            return true
        }
    }
    
    public func decode(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, nil) else {
            return nil
        }
        let properties = (CGImageSourceCopyProperties(source, nil) as? [CFString: Any]) ?? [:]
        let exifOrientation = (properties[kCGImagePropertyOrientation] as? CGImagePropertyOrientation) ?? .up
        #if os(iOS) || os(watchOS) || os(tvOS)
        let orientation = exifOrientation.iOSOrientation
        return UIImage(cgImage: image, scale: 1.0, orientation: orientation)
        #else
        return UIImage(cgImage: image, scale: 1.0, orientation: exifOrientation)
        #endif
    }
    
}

public struct ImageGIFDecoder: Decoder {
    
    public typealias Base = UIImage
    
    public init() {}
    
    public func decodable(_ data: Data) -> Bool {
        data.imageFormat == .gif
    }
    
    public func decode(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return UIImage.animatedImage(with: source)
    }
    
}
