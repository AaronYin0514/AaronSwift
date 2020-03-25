//
//  UIImage+Unzip.swift
//  AaronSwift
//
//  Created by AaronYin on 2020/3/24.
//

import Foundation
import CoreGraphics
#if os(macOS)
import AppKit.NSScreen
#endif

private var staticColorSpace: CGColorSpace?

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
    
    public class var colorSpace: CGColorSpace {
        #if os(macOS)
        if let screenColorSpace = NSScreen.main?.colorSpace?.cgColorSpace {
            return screenColorSpace
        }
        #endif
        func getColorSpace() -> CGColorSpace {
            var colorSpace: CGColorSpace
            #if os(iOS) || os(watchOS) || os(tvOS)
            if #available(iOS 9.0, tvOS 9.0, *) {
                colorSpace = CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
            } else {
                colorSpace = CGColorSpaceCreateDeviceRGB()
            }
            #else
            colorSpace = CGColorSpaceCreateDeviceRGB()
            #endif
            return colorSpace
        }
        if staticColorSpace == nil {
            staticColorSpace = getColorSpace()
        }
        return staticColorSpace!
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
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: UIImage.colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let newImageRef = context?.makeImage() else {
            return nil
        }
        return UIImage(cgImage: newImageRef)
    }
    
    
}
