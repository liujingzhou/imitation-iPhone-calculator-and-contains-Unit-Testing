//
//  File.swift
//  MYCalculator
//
//  Created by 刘景州 on 2018/8/27.
//  Copyright © 2018年 刘景州. All rights reserved.
//

import Foundation

extension String: GeneralExtension {}
    

extension ExtBaseImplementation where T == String {
    var isEmptyString: Bool {
        if original.isEmpty {
            return true
        }
        
        var tempString = original
        tempString = original.trimmingCharacters(in: .whitespaces)
        tempString = tempString.trimmingCharacters(in: .newlines)
        if original.count == 0 {
            return true
        }
        
        return false
    }
}

