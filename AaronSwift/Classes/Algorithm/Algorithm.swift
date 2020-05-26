//
//  Algorithm.swift
//  AaronSwift
//
//  Created by Aaron on 2020/5/8.
//

import Foundation

public func gcdEuclidean<I: BinaryInteger>(_ x: I, _ y: I) -> I {
    var a = x, b = y
    if a < b {
        a = a ^ b
        b = a ^ b
        a = a ^ b
    }
    var temp = a
    while(b != 0) {
        temp = a % b
        a = b
        b = temp
    }
    return a
}

public func lcmEuclidean<I: BinaryInteger>(_ x: I, _ y: I) -> I {
    let temp = gcdEuclidean(x, y)
    return x * y / temp
}

public func gcdEuclidean<I: BinaryInteger>(_ array: [I]) -> I {
    if array.count == 0 { return 0 }
    return array.reduce(0) { (x, y) -> I in
        return gcdEuclidean(x, y)
    }
}

public func lcmEuclidean<I: BinaryInteger>(_ array: [I]) -> I {
    let gcd = gcdEuclidean(array)
    let minMultiple = array.reduce(1) { (x, y) -> I in
        x * y
    }
    let pow = I(Darwin.pow(Double(gcd), Double(array.count - 1)))
    return minMultiple / pow
}

public func gcdStein<I: BinaryInteger>(_ x: I, _ y: I) -> I {
    var factor = I(0), a = x, b = y
    if a < b {
        a = a ^ b
        b = a ^ b
        a = a ^ b
    }
    if 0 == b {
        return 0
    }
    while a != b {
        if a & 0x1 > 0 {
            if b & 0x1 > 0 {
                b = (a - b) >> 1
                a -= b
            } else {
                b = b >> 1
            }
        } else {
            if b & 0x1 > 0 {
                a = a >> 1
                if a < b {
                    a = a ^ b
                    b = a ^ b
                    a = a ^ b
                }
            } else {
                a = a >> 1
                b = b >> 1
                factor += 1
            }
        }
    }
    return x << factor
}

public func lcmStein<I: BinaryInteger>(_ x: I, _ y: I) -> I {
    let temp = gcdStein(x, y)
    return x * y / temp
}
