//
//  Algorithm.swift
//  AaronSwift
//
//  Created by Aaron on 2020/5/8.
//

import Foundation

public func gcdEuclidean(_ x: Int, _ y: Int) -> Int {
    var temp = 0, a = x, b = y
    if a < b {
        temp = a
        a = b
        b = temp
    }
    while(b != 0) {
        temp = a % b
        a = b
        b = temp
    }
    return a
}

public func lcmEuclidean(_ x: Int, _ y: Int) -> Int {
    let temp = gcdEuclidean(x, y)
    return x * y / temp
}

public func gcdEuclidean(_ array: [Int]) -> Int {
    if array.count == 0 { return 0 }
    return array.reduce(0) { (x, y) -> Int in
        return gcdEuclidean(x, y)
    }
}

public func lcmEuclidean(_ array: [Int]) -> Int {
    let gcd = gcdEuclidean(array)
    let minMultiple = array.reduce(1) { (x, y) -> Int in
        x * y
    }
    let pow = Int(powl(Float80(gcd), Float80(array.count - 1)))
    return minMultiple / pow
}

public func gcdStein(_ x: Int, _ y: Int) -> Int {
    var factor = 0, temp = 0, a = x, b = y
    if a < b {
        temp = a
        a = b
        b = temp
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
                    temp = a
                    a = b
                    b = temp
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

public func lcmStein(_ x: Int, _ y: Int) -> Int {
    let temp = gcdStein(x, y)
    return x * y / temp
}
