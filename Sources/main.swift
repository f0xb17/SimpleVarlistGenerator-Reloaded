//
//  main.swift
//  SimpleVarlistGenerator written in Swift. 
//
//  Created by f0xb17 on 01/27/2025.
//

import Foundation

enum CreationErrors: Error {
  case invalidInput(String)
  case emptyInput(String)
}

struct Variables {
  var arr: [String]
  
  private func convertString(str: String) throws -> String {
    do {
      let regex = try NSRegularExpression(pattern: #"^\(L\.([L$])\.([a-zA-Z0-9_]+)\)$"#)
      let range = NSRange(location: 0, length: str.utf16.count)
      if let match = regex.firstMatch(in: str, options: [], range: range) {
        return String(str[Range(match.range(at: 2), in: str)!])
      }
      throw CreationErrors.invalidInput("Invalid input! Input should be in the following format: (L.L.variable) or (L.$.variable)")
    } catch {
      print(error)
    }
    return ""
  }

  private func cleanArray(arr: [String]) throws -> [String] {
    guard arr.isEmpty == false else {
      throw CreationErrors.emptyInput("Array is empty! Array should not be empty!")
    }
    var cleanedArr = [String]()
    do {
      for var item in arr {
        item = try convertString(str: item)
        if !cleanedArr.contains(item) {
          cleanedArr.append(item)
        }
      }
    } catch {
      print(error)
    }
    return cleanedArr
  }

  private func cleanArrays(arr: [String]) -> ([String], [String]) {
    do {
      var (varArray, stringvarArray) = ([String](), [String]()) 
      for item in arr {
        if item.contains("$") {
          stringvarArray.append(item)
        } else {
          varArray.append(item)
        }
      }
      return(try cleanArray(arr: varArray), try cleanArray(arr: stringvarArray))
    } catch {
      print(error)
    }
    return ([String](), [String]())
  }

  func create() -> ([String], [String]) {
    return cleanArrays(arr: arr)
  }
}

@main
struct SimpleVarlistGenerator {
  static func main() {
    let variables = Variables(arr: ["(L.L.variable)", "(L.L.variable1)", "(L.L.variable3)", "(L.L.variable4)", "(L.$.stringVariable)", "(L.$.stringVariable1)", "(L.$.stringVariable2)", "(L.$.stringVariable3)", "(L.L.variable1)", "(L.L.variable2)", "(L.L.variable3)", "(L.$.stringVariable3)"])
    //let variables = Variables(arr: [""])
    let (varArray, stringvarArray) = variables.create()
    print(varArray)
    print(stringvarArray)
  }
}
