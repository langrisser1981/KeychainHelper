//  ContentView.swift
//  KeyChainHelper
//
//  Created by 程信傑 on 2022/12/6.
//

import SwiftUI

struct ContentView: View {
    // 就跟平常使用狀態變數一樣，但要指定key的名稱，與所屬的群組
    // 使用時不需要指定初始值，因為我們有自定init，只需要傳入key & account，不需要傳入wrappedValue
    // 有了自訂init就會蓋過原本內建的memberwise-init
    @KeyChain(key: "password", account: "test") var numString
    @State var num = 0

    var body: some View {
        VStack {
            Text("目前的key值: \(numString ?? "")")
            
            Button {
                num += 1
                numString = num.formatted() // 將值寫回keychain
            } label: {
                Text("將key值加1後回存keychain")
            }

            Button {
                num = 0
                numString = nil // 指定為nil可以刪除key
            } label: {
                Text("刪除key值")
            }
        }
        .onAppear {
            num = Int(numString ?? "") ?? 0
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
