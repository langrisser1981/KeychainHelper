# KeychainHelper
---
> 密碼跟金鑰應該加密保存在keychain，不能直接保存在UserDefaults，否則第三方程式可以輕鬆讀取這些值

## 實作細節
  1. 建立一個helper，負責資料的CRUD
   - 透過單例存取
   - 提供save & read & delete三個方法
   - 寫入時如果發現該key已經有值，則更新該key所對應的值
  2. 建立一個自訂的property wrapper，有下列特性
   - 實作dynamicProperty，讓這個包裝可以跟@State狀態屬性一樣，當值變動時，可以自動更新關聯的所有view
   - 接收String，在內部轉換為Data寫入keychain
   - 使用方式就跟一般的@UserDefaults相同

![展示畫面](./Keychain_gif.gif "展示畫面")


