//
//  KeyChainPropertyWrapper.swift
//  KeyChainHelper
//
//  Created by 程信傑 on 2022/12/6.
//

import SwiftUI

@propertyWrapper
struct KeyChain: DynamicProperty {
    // 將實際的值存放在一個狀態變數，才能符合nonmutating & 更新關聯的view
    @State var data: Data?

    var wrappedValue: String? {
        get {
            // 每次讀取包裝值時，如果都從keychain中讀取，就可以確保讀到的一定是目前keychain中的值
            // 但經過測試，如果getter中沒有存取到@State狀態屬性，外部的關聯view就不會被一起更新
            // 且為了避免重複存取keychain，造成資源浪費，直接讀取內部值就可以
            // 這邊測試過，讀取keychain與直接讀取內部值，兩者的值是相同的，所以可以安心使用
            /*
             guard let keychainData = KeyChainService.shared.read(key: key, account: account),
                   let keychainValue = String(data: keychainData, encoding: .utf8)
             else {
                 return nil
             }
             print("read_keychain: \(keychainValue)")
                 */

            // 直接讀取包裝內的值，並轉換成字串
            guard let currentData = data,
                  let currentValue = String(data: currentData, encoding: .utf8)
            else {
                return nil
            }
            // print("read_current: \(currentValue)")
            return currentValue
        }
        nonmutating set {
            // 檢查是否將值設定為nil，如果將值設定為nil，代表要刪除這個key
            guard let newValue else {
                KeyChainService.shared.delete(key: key, account: account)
                data = nil
                return
            }

            // 如果新值非nil，就新增(更新)值
            guard let newData = newValue.data(using: .utf8) else {
                print("無法將值轉換為data")
                return
            }

            KeyChainService.shared.save(data: newData, key: key, account: account)
            data = newData
        }
    }

    var key: String
    var account: String
    init(key: String, account: String) {
        self.key = key
        self.account = account
        // 讀取key值，作為狀態變數的初始值；確保程式在第一次載入時，會去keychain中讀取保存在裝置中的值，如果找不到就設為nil
        _data = State(wrappedValue: KeyChainService.shared.read(key: key, account: account))
    }
}
