//
//  JZEX.swift
//  MYCalculator
//
//  Created by 刘景州 on 2018/8/27.
//  Copyright © 2018年 刘景州. All rights reserved.
//

import Foundation


/// 扩展的protocol：用于扩展具体的功能
protocol GeneralExtension {
    associatedtype DT
    /// 访问原来的value
    var jz: DT { get }
}

/// 扩展基础实现:
public final class ExtBaseImplementation<T> {
    typealias DT = T
    public let original: T
    
    public init(_ original: T) {
        self.original = original
    }
}


extension GeneralExtension {
    var jz: ExtBaseImplementation<Self> {
        return ExtBaseImplementation(self)
    }
}
