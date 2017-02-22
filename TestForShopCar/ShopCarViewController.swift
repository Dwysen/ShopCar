//
//  ReceiptAddressView.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  小熊的新浪微博:http://weibo.com/5622363113/profile?topnav=1&wvr=6

import UIKit

class ShopCarViewController : UIViewController {
    
    fileprivate var tableHeadView = UIView()
    fileprivate var isFristLoadData = false
    fileprivate var receiptAdressView: ReceiptAddressView?
    fileprivate let supermarketTableView  = LFBTableView(frame: CGRect(x: 0, y: NavigationH, width: ScreenWidth, height: ScreenHeight - NavigationH - 50 ), style: .plain)
    fileprivate let tableFooterView = ShopCartSupermarketTableFooterView()
    
    
    override func viewDidLoad() {
        view.backgroundColor = LFBGlobalBackgroundColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddGoods))
        
   
        NotificationCenter.default.addObserver(self, selector: #selector(shopCarProductsDidRemove), name: NSNotification.Name(rawValue: LFBShopCarDidRemoveProductNSNotification), object: nil)
    }
    
    func AddGoods(){
        
        // test
        let goods = Goods()
        goods.name = "Good"
        goods.id = "1"
        goods.price = "88"

        goods.partner_price = "88"
        goods.number = 999
        goods.userBuyNumber = 1
        UserShopCarTool.sharedUserShopCar.addSupermarkProductToShopCar(goods)
        NotificationCenter.default.post(name: Notification.Name(rawValue: LFBShopCarBuyPriceDidChangeNotification), object: nil, userInfo: nil)
        supermarketTableView.reloadData()
        
    }
    
    func shopCarBuyPriceDidChange() {
        tableFooterView.priceLabel.text = UserShopCarTool.sharedUserShopCar.getAllProductsPrice()
    }
    
    func shopCarProductsDidRemove() {
        
//        if UserShopCarTool.sharedUserShopCar.isEmpty() {
//            showshopCarEmptyUI()
//        }
        
        self.supermarketTableView.reloadData()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        weak var tmpSelf = self
        
        //        if userShopCar.isEmpty() {
        //            showshopCarEmptyUI()
        //        } else
        //            {
        //
        //            if !ProgressHUDManager.isVisible() {
        //                ProgressHUDManager.setBackgroundColor(UIColor.colorWithCustom(230, g: 230, b: 230))
        //                ProgressHUDManager.showWithStatus("正在加载商品信息")
        //            }
        //
        let time = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
            
        tmpSelf!.self.showProductView()
            
//       ProgressHUDManager.dismiss()
        }
    }
    
    
    fileprivate func addNSNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(shopCarProductsDidRemove), name: NSNotification.Name(rawValue: LFBShopCarDidRemoveProductNSNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(shopCarBuyPriceDidChange), name: NSNotification.Name(rawValue: LFBShopCarBuyPriceDidChangeNotification), object: nil)
    }
    
    fileprivate func buildTableHeadView() {
        
        tableHeadView.frame = CGRect(x: 0, y: 0, width: view.width, height: 250)
        
        addNSNotification()
        buildReceiptAddress()
        
//        buildMarketView()
//        
//        buildSignTimeView()
//        
//        buildSignComments()
    }
    
    
    fileprivate func showProductView() {
        
//        if !isFristLoadData {
        
        buildTableHeadView()
        
        buildSupermarketTableView()
        
        isFristLoadData = true
        
//        }
    
    }
    
    fileprivate func buildSupermarketTableView() {
        supermarketTableView.tableHeaderView = tableHeadView
        supermarketTableView.backgroundColor = view.backgroundColor
        tableFooterView.frame = CGRect(x: 0, y: ScreenHeight - 50, width: ScreenWidth, height: 50)
        view.addSubview(tableFooterView)
        tableFooterView.delegate = self
        supermarketTableView.delegate = self
        supermarketTableView.dataSource = self
        supermarketTableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0)
        supermarketTableView.rowHeight = ShopCartRowHeight
        view.addSubview(supermarketTableView)
    }
    
    fileprivate func buildReceiptAddress() {
        
        receiptAdressView = ReceiptAddressView(frame: CGRect(x: 0, y: 10, width: view.width, height: 70), modifyButtonClickCallBack: { () -> () in
            
        })
        
        tableHeadView.addSubview(receiptAdressView!)
        view.addSubview(tableHeadView)
        //        if UserInfo.sharedUserInfo.hasDefaultAdress() {
        //            receiptAdressView?.adress = UserInfo.sharedUserInfo.defaultAdress()
        //        } else {
        //            weak var tmpSelf = self
        //            AdressData.loadMyAdressData { (data, error) -> Void in
        //                if error == nil {
        //                    if data!.data?.count > 0 {
        //                        UserInfo.sharedUserInfo.setAllAdress(data!.data!)
        //                        tmpSelf!.receiptAdressView?.adress = UserInfo.sharedUserInfo.defaultAdress()
        //                    }
        //                }
        //            }
        //        }
        
    }
    
}

// MARK: - ShopCartSupermarketTableFooterViewDelegate
extension ShopCarViewController: ShopCartSupermarketTableFooterViewDelegate {
    
    func supermarketTableFooterDetermineButtonClick() {
       
        print("Pay")
    }
}

// MARK: - UITableViewDeletate UITableViewDataSource
extension ShopCarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserShopCarTool.sharedUserShopCar.getShopCarProductsClassifNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShopCartCell.shopCarCell(tableView)
        cell.goods = UserShopCarTool.sharedUserShopCar.getShopCarProducts()[indexPath.row]
        
        return cell
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        commentsView.textField.endEditing(true)
    //    }
}
