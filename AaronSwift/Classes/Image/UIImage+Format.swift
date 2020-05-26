//
//  UIImage+Format.swift
//  AaronSwift
//
//  Created by Aaron on 2020/5/26.
//

import Foundation

private var UIImageFormatKey = "UIImageFormat"

extension UIImage {
    
    public var fromat: ImageFormat? {
        set(v) {
            objc_setAssociatedObject(self, &UIImageFormatKey, v?.rawValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            guard let f = objc_getAssociatedObject(self, &UIImageFormatKey) as? String else {
                return nil
            }
            return ImageFormat(rawValue: f)
        }
    }
    
}

public enum ImageFormat: String {
    case undefined = "undefined"
    case jpeg = "jpeg"
    case png = "png"
    case gif = "gif"
    case tiff = "tiff"
    case webP = "webP"
    case heic = "heic"
    case heif = "heif"
}

extension Data {
    
    public var imageFormat: ImageFormat {
        var c: UInt8 = UInt8()
        copyBytes(to: &c, count: 1)
        switch c {
        case 0xFF:
            return .jpeg
        case 0x89:
            return .png
        case 0x47:
            return .gif
        case 0x49, 0x4D:
            return .tiff
        case 0x52:
            if (self as NSData).length >= 12 {
                //RIFF....WEBP
                guard let range = Range<Data.Index>(NSRange(location: 0, length: 12)) else {
                    return .undefined
                }
                let data = subdata(in: range)
                guard let string = String(data: data, encoding: .ascii) else {
                    return .undefined
                }
                if string.hasPrefix("RIFF") && string.hasSuffix("WEBP") {
                    return .webP
                }
            }
        case 0x00:
            if (self as NSData).length >= 12 {
                //....ftypheic ....ftypheix ....ftyphevc ....ftyphevx
                guard let range = Range<Data.Index>(NSRange(location: 4, length: 8)) else {
                    return .undefined
                }
                let data = subdata(in: range)
                guard let string = String(data: data, encoding: .ascii) else {
                    return .undefined
                }
                if string == "ftypheic" || string == "ftypheix" || string == "ftyphevc" || string == "ftyphevx" {
                    return .heic
                }
                if string == "ftypmif1" || string == "ftypmsf1" {
                    return .heif
                }
            }
        default:
            return .undefined
        }
        return .undefined
    }
    
}
