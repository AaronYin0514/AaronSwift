//
//  UIImage+Unzip.swift
//  AaronSwift
//
//  Created by AaronYin on 2020/3/24.
//

import Foundation
import CoreGraphics

extension UIImage {
    
    public var containsAlphaChannel: Bool? {
        if let image = cgImage {
            return UIImage.containsAlphaChannel(by: image)
        }
        return nil
    }
    
    public class func containsAlphaChannel(by image: CGImage) -> Bool {
        let alphaInfo = CGImageAlphaInfo(rawValue: image.alphaInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
        var hasAlpha = false
        if alphaInfo == .premultipliedLast || alphaInfo == .premultipliedFirst || alphaInfo == .last || alphaInfo == .first {
            hasAlpha = true
        }
        return hasAlpha
    }
    
    public func unzip() -> UIImage? {
        guard let imageRef = cgImage else {
            return nil
        }
        let width = imageRef.width
        let height = imageRef.height
        let hasAlpha = containsAlphaChannel ?? false
        var bitmapInfo = CGBitmapInfo.byteOrder32Little
        let value = bitmapInfo.rawValue | (hasAlpha ? CGImageAlphaInfo.premultipliedFirst.rawValue : CGImageAlphaInfo.noneSkipFirst.rawValue)
        bitmapInfo = CGBitmapInfo(rawValue: value)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue)
        context?.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let newImageRef = context?.makeImage() else {
            return nil
        }
        return UIImage(cgImage: newImageRef)
    }
    
    
}
