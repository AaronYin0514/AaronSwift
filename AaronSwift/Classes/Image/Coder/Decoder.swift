//
//  Decoder.swift
//  AaronSwift
//
//  Created by Aaron on 2020/5/15.
//

import Foundation

protocol Decoder {
    
    associatedtype Base
    
    func decodable(_ data: Data) -> Bool
    
    func decode(_ data: Data) -> Base
    
}


