//
//  KeychainService.swift
//  KeyChainHelper
//
//  Created by 程信傑 on 2022/12/6.
//

import Foundation
import Security

class KeyChainService {
    // 建立一個單例，透過它來存取服務
    static var shared = KeyChainService()
    
    // MARK: 新增(更新)一個值

    func save(data: Data, key: String, account: String) {
        // 建立查詢規則
        let query = [
            kSecValueData: data, // 寫入的資料
            kSecAttrService: key, // 識別符號，資料對應的名稱
            kSecAttrAccount: account, // 識別符號，資料對應的群組
            kSecClass: kSecClassGenericPassword // 資料類型，這邊是密碼
        ] as CFDictionary // 需要轉型成CFDictionary
        
        // 執行查詢
        let status = SecItemAdd(query, nil)
        
        // 根據結果做處理
        switch status {
        // 成功
        case errSecSuccess:
            print("\(key):儲存成功")
            
        // 如果這個key已經有值了，就改成更新值，而不是新增
        case errSecDuplicateItem:
            let updateQuery = [
                kSecAttrService: key,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            
            let updateField = [kSecValueData: data] as CFDictionary
            
            // 更新值
            if SecItemUpdate(updateQuery, updateField) == 0 {
                print("\(key):更新成功")
            } else {
                print("\(key):更新失敗")
            }
            
        // 其他失敗
        default:
            print("\(key):發生錯誤:\(status)")
        }
    }
    
    // MARK: 讀取值，如果找不到對應的key，回傳的結果是一個空值

    func read(key: String, account: String) -> Data? {
        let query = [
            kSecAttrService: key,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true // 要將kSecReturnData設為true，才會回傳kSecValueData
        ] as CFDictionary
        
        // 用來存放讀值的結果，可能是nil
        var resultData: AnyObject?
        SecItemCopyMatching(query, &resultData) // 讀取值
        
        return resultData as? Data
    }
    
    // MARK: 刪除值

    func delete(key: String, account: String) {
        let query = [
            kSecAttrService: key,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        SecItemDelete(query) // 刪除值
    }
}
