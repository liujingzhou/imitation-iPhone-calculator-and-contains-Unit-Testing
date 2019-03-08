//
//  ViewController.swift
//  MYCalculator
//
//  Created by 刘景州 on 2018/8/22.
//  Copyright © 2018年 刘景州. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    enum ButtonName: Int {
        case One = 1
        case Two
        case Three
        case Four
        case Five
        case Six
        case Seven
        case Eight
        case Nine
        case Zero
        case Dot
        case Ac
        case SwitchNegativeOrPositive
        case Residual
        case Division
        case Multiplication
        case Sub
        case Add
        case Equal
        case Undefine
    }
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    var isNeedCleanLableText: Bool = false
    var saveLastOperatorTag: ButtonName = .Undefine
    var saveLastClickTag: ButtonName = .Undefine
    var saveArrayAfterClickEqucl: [String] = []
    var calculateArray: [String] = [] {
        willSet {
            DebugTool.JZLogLine(newValue)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.addObserver(self, forKeyPath: "text", options: [.new, .old], context: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        resetButton .setTitle("C", for: .normal)
        let buttonTag: ButtonName = ViewController.ButtonName(rawValue: sender.tag)!
        dealButtonClickWith(buttonTag: buttonTag, clickButton: sender)
        saveLastClickTag = buttonTag
    }
    
    deinit {
        resultLabel.removeObserver(self, forKeyPath: "text")
    }
}

// MARK: - Private Method
extension ViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "text" else {
            return
        }
        
        if let value = change?[NSKeyValueChangeKey.newKey] as? String {
            
            guard (value as NSString).length > 9 else {
                return
            }
            
            guard !(value.contains("e")) else {
                showMessageBox("超出范围")
                return
            }
            
            guard !(value.contains(".")) else {
                resultLabel.text = interception(originalString: value, offset: 9)
                resultLabel.text = deleteTailZeroOrDotFrom(resultString: resultLabel.text!)
                return
            }
            if tagIsOperator(tag: saveLastClickTag) || saveLastClickTag == .Equal {
                showMessageBox("超出范围")
            } else {
                resultLabel.text = interception(originalString: value, offset: 9)
            }
        }
    }
    
    func interception(originalString: String, offset: Int) -> String {
        let subString = String(originalString[..<originalString.index(originalString.startIndex, offsetBy: offset)])
        return subString
    }
    
    func dealButtonClickWith(buttonTag: ButtonName, clickButton: UIButton) {
        var input = "0"
        switch buttonTag {
        case .Zero:
            input = "0"
        case .Dot:
            if saveLastClickTag == .Equal {
                resultLabel.text = "0"
            }
            if !(resultLabel.text?.contains("."))! {
                input = "."
            } else {
                input = ""
            }
        case .Ac:
            clearData()
            return
        case .SwitchNegativeOrPositive:
            input = "-"
        case .Residual:
            input = resultLabel.text!
        case .Division:
            change(theOperator: "/", buttonTag: buttonTag)
        case .Multiplication:
            change(theOperator: "x", buttonTag: buttonTag)
        case .Sub:
            change(theOperator: "-", buttonTag: buttonTag)
        case .Add:
            change(theOperator: "+", buttonTag: buttonTag)
        case .Equal:
            if input != "-" && resultLabel.text != "-" {
                calculation(buttonTag: buttonTag)
            } else {
                resultLabel.text = "0"
            }
        default:
            input = (clickButton.titleLabel?.text)!
        }
        dealOperationLogicWith(buttonTag, clickButton, input)
    }
    
    func dealOperationLogicWith(_ buttonTag: ButtonName, _ clickButton: UIButton, _ input: String) {
        guard clickButton.tag < 15 else {
            return
        }
        
        guard resultLabel.text != "0" else {
            if buttonTag == .Dot {
                resultLabel.text = "0" + input
            } else {
                resultLabel.text = input
            }
            return
        }
        
        switch buttonTag {
        case .SwitchNegativeOrPositive:
            if (resultLabel.text! as NSString).doubleValue > 0 {
                resultLabel.text = input + resultLabel.text!
            } else {
                resultLabel.text?.removeFirst(1)
                if resultLabel.text == "" {
                    resultLabel.text = "0"
                }
            }
        case .Residual:
            if input != "-" {
                let inputDouble = Double(input)! / 100.00
                resultLabel.text = String(inputDouble)
            } else {
                resultLabel.text = "0"
            }
        default:
            if self.isNeedCleanLableText {
                self.isNeedCleanLableText = false
                resultLabel.text = ""
            }
            resultLabel.text = resultLabel.text! + input
        }
    }
    
    func change(theOperator: String, buttonTag: ButtonName) {
        if tagIsOperator(tag: buttonTag) && tagIsOperator(tag: saveLastClickTag) {
            calculateArray.removeLast()
            calculateArray.append(theOperator)
            return
        }
        
        calculateArray.append(resultLabel.text!)
        
        if buttonTag == .Add || buttonTag == .Sub || saveLastOperatorTag == .Division || saveLastOperatorTag == .Multiplication {
            if calculateArray.count > 2 {
                calculation(buttonTag: buttonTag)
            }
        }
        
        calculateArray.append(theOperator)
        self.saveLastOperatorTag = buttonTag

        guard calculateArray.count == 2 && calculateArray[0] == "0" else {
            self.isNeedCleanLableText = true
            return
        }
    }
    
    func tagIsOperator(tag: ButtonName) -> Bool {
        if tag == .Add || tag == .Sub || tag == .Division || tag == .Multiplication {
            return true
        }
        return false
    }
    
    func calculation(buttonTag: ButtonName) {
        if !tagIsOperator(tag: buttonTag) && saveLastClickTag != .Equal {
            calculateArray.append(resultLabel.text!)
        }
        
        if buttonTag == .Equal && saveLastClickTag == .Equal {
            saveArrayAfterClickEqucl.insert(resultLabel.text!, at: 0)
            calculateArray = saveArrayAfterClickEqucl
        }
        
        if Calculator.judgeDivisorIsEqualZero(numberArray: calculateArray) {
            showMessageBox("除数不能为0")
        }
        
        let resultNum = Calculator.calculatorExpression(Calculator.exchangeCalculateArrayToString(array: calculateArray))
        if buttonTag == .Equal {
            saveArrayAfterClickEqucl.removeAll()
            if calculateArray.count >= 2 {
                saveArrayAfterClickEqucl.append(calculateArray[calculateArray.endIndex - 2])
                saveArrayAfterClickEqucl.append(calculateArray.last!)
            }
            calculateArray.removeAll()
        }
        saveLastClickTag = buttonTag
        self.resultLabel.text = deleteTailZeroOrDotFrom(resultString: "\(resultNum)")
    }
    
    func clearData() {
        resultLabel.text = "0"
        self.saveLastClickTag = .Undefine
        self.saveLastOperatorTag = .Undefine
        self.saveArrayAfterClickEqucl = []
        self.isNeedCleanLableText = false
        calculateArray.removeAll()
        saveArrayAfterClickEqucl.removeAll()
        resetButton .setTitle("AC", for: .normal)
    }
    
    func deleteTailZeroOrDotFrom(resultString: String) -> String {
        var tempString = resultString
        let lastStr = tempString[tempString.index(tempString.endIndex, offsetBy: -1)] //获取最后一个字符
        
        if lastStr == "0" {
            tempString.remove(at: tempString.index(tempString.endIndex, offsetBy: -1))
            return deleteTailZeroOrDotFrom(resultString: tempString)
        } else if lastStr == "." {
            tempString.remove(at: tempString.index(tempString.endIndex, offsetBy: -1))
        }
        return tempString
    }
    
    func showMessageBox(_ message: String, _ title: String = "提示") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        clearData()
    }
}
