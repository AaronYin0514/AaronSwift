//
//  UIImage+Unzip.swift
//  AaronSwift
//
//  Created by AaronYin on 2020/3/24.
//

import Foundation
import CoreGraphics

extension UIImage{
    
    public func unzip() -> UIImage? {
        guard let imageRef = cgImage else {
            return nil
        }
        let width = imageRef.width
        let height = imageRef.height
        let alphaInfo = CGImageAlphaInfo(rawValue: imageRef.alphaInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
        var hasAlpha = false
        if alphaInfo == .premultipliedLast || alphaInfo == .premultipliedFirst || alphaInfo == .last || alphaInfo == .first {
            hasAlpha = true
        }
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
