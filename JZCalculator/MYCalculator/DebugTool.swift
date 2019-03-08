//
//  Tool.swift
//  MYCalculator
//
//  Created by 刘景州 on 2018/8/27.
//  Copyright © 2018年 刘景州. All rights reserved.
//

import Foundation




class DebugTool {
    
    /// 直接打印出内容
    ///
    /// - Parameter message: 打印消息
    static func JZLog<T>(_ message: T) {
        #if DEBUG
        print("\(message)")
        #endif
    }
    
    /// 打印内容，并包含类名和打印所在行数
    ///
    /// - Parameters:
    ///   - message: 打印消息
    ///   - file: 打印所属类
    ///   - lineNumber: 打印语句所在行数
    static func JZLogLine<T>(_ message: T, file: String = #file, lineNumber: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):line:\(lineNumber)]- \(message)")
        #endif
    }
}


