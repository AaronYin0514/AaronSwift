//
//  ImageFilter.swift
//  AaronSwift
//
//  Created by Aaron on 2020/4/24.
//

import Foundation

public typealias ImageFilter = (CIImage) -> CIImage

public func gaussianBlur(radius: Double) -> ImageFilter {
    return { image in
        let parameters: [String : Any] = [kCIInputRadiusKey: radius, kCIInputImageKey: image]
        guard let filter = CIFilter(name: "CIGaussianBlur", parameters: parameters) else {
            fatalError()
        }
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage
    }
}

public func colorGenerator(_ color: UIColor) -> ImageFilter {
    return { _ in
        let c = CIColor(color: color)
        let parameters = [kCIInputColorKey: c]
        guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters) else {
            fatalError()
        }
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage
    }
}

public func compositeSourceOver(_ overlay: CIImage) -> ImageFilter {
    return { image in
        let parameters = [kCIInputBackgroundImageKey: image, kCIInputImageKey: overlay]
        guard let filter = CIFilter(name: "CISourceOverCompositing", parameters: parameters) else {
            fatalError()
        }
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        let cropRect = image.extent
        return outputImage.cropped(to: cropRect)
    }
}

public func colorOverlay(_ color: UIColor) -> ImageFilter {
    return { image in
        let overlay = colorGenerator(color)(image)
        return compositeSourceOver(overlay)(image)
    }
}

infix operator >>> : ImageFilterPrecedence
precedencegroup ImageFilterPrecedence {
    associativity: left
}
public func >>>(filter1: @escaping ImageFilter, filter2: @escaping ImageFilter) -> ImageFilter {
    return { image in
        filter2(filter1(image))
    }
}
