//
//  Calculator.swift
//  Calculator
//
//  Created by LJZ on 2018/8/25.
//  Copyright © 2018年 LJZ. All rights reserved.
//

/*
 这是一个计算类，对外提供calculatorExpression接口传入一个字符串进行计算，如果是数组可以用exchangeCalculateArrayToString转成字符串进行计算
 计算的算法是采用节点拆分的方式递归进行计算
 */

import Foundation

// 基本运算符
let basicOperatorList: [String] = ["+", "-", "x", "/"]

enum ComputeError: Error {
    case Empty
    case InvalidOperator
    case SyntaxAnalysisError
}

enum OperatorType {
    case undefine, Add, Sub, Multiplication, Division
    
    static func toOperatorType(symbol: String) -> OperatorType {
        switch symbol {
        case "+":
            return OperatorType.Add
        case "-":
            return OperatorType.Sub
        case "x":
            return OperatorType.Multiplication
        case "/":
            return OperatorType.Division
        default:
            return OperatorType.undefine
        }
    }
}

struct Node {
    var value: Double = Double() // 节点值
    var nodeOperator: OperatorType = .undefine   // 节点运算
    var nodeList: [Node] = []  // 节点列表
    
    private func isExpression(_ expression: String) throws -> Bool {
        guard !expression.jz.isEmptyString else {
            throw ComputeError.SyntaxAnalysisError
        }
        
        // 检测是否存在运算符: 如果存在运算符那就是一个表达式
        return expression.contains { (char: Character) -> Bool in
            return basicOperatorList.contains(String(char))
        }
    }
    
    mutating func compute(_ expression: String) -> Double {
        do {
            if !(try isExpression(expression)) {
                
                var tempExpression = expression
                if tempExpression.contains("m") {
                    tempExpression = tempExpression.replacingOccurrences(of: "m", with: "-")
                }
                
                if let value = Double(tempExpression) {
                    self.value = value
                    return self.value
                }
            }
        } catch ComputeError.SyntaxAnalysisError {
            DebugTool.JZLogLine("语法错误")
            return Double()
        } catch {}
        
        // 拆分运算符为每个节点后计算
        var operationSymbol: String = ""
        for operation in basicOperatorList {
            if expression.contains(operation) {
                operationSymbol = operation
                break
            }
        }
        
        let expressionList: [String] = expression.components(separatedBy: operationSymbol)
        
        var index: Int = 0
        for tempExpression in expressionList {
            var childNode = Node()
            self.nodeOperator = OperatorType.toOperatorType(symbol: operationSymbol)
            self.nodeList.insert(childNode, at: self.nodeList.endIndex)
            // 计算节点值
            if index == 0 {
                self.value = childNode.compute(tempExpression)
            } else {
                switch self.nodeOperator {
                case .Add:
                    self.value += childNode.compute(tempExpression)
                case .Sub:
                    self.value -= childNode.compute(tempExpression)
                case .Multiplication:
                    self.value *= childNode.compute(tempExpression)
                case .Division:
                    self.value /= childNode.compute(tempExpression)
                default:
                    DebugTool.JZLogLine("undefine")
                }
            }
            
            index += 1
        }
        return self.value
    }
}


class Calculator {
    
    static func syntaxAnalysis(_ expression: String) -> (description: String, code: ComputeError)? {
        guard !expression.jz.isEmptyString else {
            return ("表达式为空", ComputeError.Empty)
        }
        return nil
    }
    
    private static func filter(_ expression: String, condition: (() -> String)?) -> String {
        var filterString = String()
        if let callback = condition {
            filterString = callback()
        } else {
            return expression
        }
        
        return expression.replacingOccurrences(of: filterString, with: "")
    }
    
    static func calculatorExpression(_ expression: String) -> Double {
        // 语法分析
        if let error = syntaxAnalysis(expression) {
            DebugTool.JZLogLine("ERROR: description:\(error.description) code:\(error.code)")
            return Double()
        }
        
        // 过滤无用字符
        let afterExpression = filter(expression) { () -> String in
            return " "
        }
        
        // 节点解析，计算
        var mainNode = Node()
        return mainNode.compute(afterExpression)
    }
    
    @discardableResult
    static func judgeDivisorIsEqualZero(numberArray: [String]) -> Bool {
        for (i, value) in numberArray.enumerated() {
            if value == "/" && i < numberArray.count && numberArray[i + 1] == "0" {
                return true
            }
        }
        return false
    }
    
    
    static func exchangeCalculateArrayToString(array: [String]) -> String {
        var calculateString = ""
        var targetString = ""
        for tempString in array {
            targetString = tempString
            if targetString.contains("-") && (targetString as NSString).length > 1 {
                targetString = targetString.replacingOccurrences(of: "-", with: "m")
            }
            calculateString.append(targetString)
        }
        DebugTool.JZLogLine(calculateString)
        return calculateString
    }
}



