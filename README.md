# FlickrApp-RxSwift-MVVM-Realm
FlickrDemoApp with Rx+MVVM using Realm as database

不需要執行pod install  
已知可優化or問題：  
 - 讀取圖片前可先抓取圖片可提供的大小避免預設中等圖片大小無法讀取到小圖的問題
 - 下載圖片至本地端前同上
 - Favorite頁面目前僅有呈現已加入到我的最愛的圖片功能
