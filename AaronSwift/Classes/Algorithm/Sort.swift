//
//  Sort.swift
//  AaronSwift
//
//  Created by AaronYin on 2020/2/25.
//

import Foundation

public struct Sort {
    
    public static func bubbleSort<T>(_ arr:Array<T>, change: (_ value1: T, _ value2: T) -> Bool) -> Array<T> {
        var tmpArr = arr
        var tmp: T
        let count = tmpArr.count
        for i in 0..<count - 1 {
            for j in 0..<count - 1 - i {
                if change(tmpArr[j], tmpArr[j + 1]) {
                    tmp = tmpArr[j]
                    tmpArr[j] = tmpArr[j + 1]
                    tmpArr[j + 1] = tmp
                }
            }
        }
        return tmpArr
    }

    public static func selectSort<T>(_ arr:Array<T>, change: (_ value1: T, _ value2: T) -> Bool) -> Array<T> {
        var tmpArr = arr
        var tmp: T
        let count = tmpArr.count
        var minIndex: Int = 0
        for i in 0..<count {
            minIndex = i
            for j in i + 1..<count {
                if change(tmpArr[minIndex], tmpArr[j]) {
                    minIndex = j
                }
            }
            if i != minIndex {
                tmp = tmpArr[i]
                tmpArr[i] = tmpArr[minIndex]
                tmpArr[minIndex] = tmp
            }
        }
        return tmpArr
    }
    
}


