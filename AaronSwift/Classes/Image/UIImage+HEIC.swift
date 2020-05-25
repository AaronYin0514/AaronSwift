//
//  UIImage+HEIC.swift
//  AaronSwift
//
//  Created by Aaron on 2020/5/19.
//

import UIKit

extension UIImage {
    
    public static let heicDecodable: Bool = {
        if #available(iOS 11.0, OSX 10.13, tvOS 11.0, *) {
            return true
        }
        return false
    }()
    
}
