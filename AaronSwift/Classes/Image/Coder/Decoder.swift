//
//  Decoder.swift
//  AaronSwift
//
//  Created by Aaron on 2020/5/15.
//

import Foundation

public protocol DecoderProtocol {
    
    associatedtype Base
    
    func decodable(_ data: Data) -> Bool
    
    func decode(_ data: Data) -> Base?
    
}

public protocol ImageDecoderProtocol: DecoderProtocol {
    
    var scale: CGFloat { set get }
    
}

public struct ImageDecoder: ImageDecoderProtocol {
    
    public typealias Base = UIImage
    
    public var scale: CGFloat = 1.0
    
    public init(scale: CGFloat = 1.0) {
        self.scale = scale
    }
    
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
        let scaleFactor = (scale < 0 || scale > 1) ? 1.0 : scale
        return UIImage.animatedImage(with: data, scale: scaleFactor)
    }
    
}

public protocol GIFDecoderProtocol: ImageDecoderProtocol {
    
    var preserveAspectRatio: Bool { set get }
    
    var thumbnailPixelSize: CGSize { set get }
    
}

public struct ImageGIFDecoder: GIFDecoderProtocol {
    
    public typealias Base = UIImage
    
    public var scale: CGFloat
    
    public var preserveAspectRatio: Bool
    
    public var thumbnailPixelSize: CGSize
    
    public init(scale: CGFloat = 1.0, preserveAspectRatio: Bool = true, thumbnailPixelSize: CGSize = .zero) {
        self.scale = scale
        self.preserveAspectRatio = preserveAspectRatio
        self.thumbnailPixelSize = thumbnailPixelSize
    }
    
    public func decodable(_ data: Data) -> Bool {
        data.imageFormat == .gif
    }
    
    public func decode(_ data: Data) -> UIImage? {
        let scaleFactor = (scale < 0 || scale > 1) ? 1.0 : scale
        return UIImage.animatedImage(with: data, scale: scaleFactor, preserveAspectRatio: preserveAspectRatio, thumbnailPixelSize: thumbnailPixelSize)
    }
    
}
