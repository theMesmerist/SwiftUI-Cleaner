

import Foundation
import StoreKit
import SwiftyStoreKit
import UIKit

var priceMonthly = String()
var priceAnnual = String()

let monthlyProductID = "unlock.cleaner.monthly"
let annualProductID = "unlock.cleaner.annual"

var arrAllProducts = [monthlyProductID, annualProductID]

class StoreKitOperations {
    let sharedSecret = "530a2f7d44c74bdcaa72cb097c5c04ef"
        
    func configureStoreKit() {
        // see notes below for the meaning of Atomic / Non-Atomic
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
    }
        
    func retriveProductInfo(productID: String) {
        SwiftyStoreKit.retrieveProductsInfo([productID]) { result in
            if let product = result.retrievedProducts.first {
                let price = product.localizedPrice
                    
                switch productID {
                case monthlyProductID:
                    priceMonthly = price!
                    uDefaults.setValue(priceMonthly, forKey: "priceMonthly")
                case annualProductID:
                    priceAnnual = price!
                    uDefaults.setValue(priceAnnual, forKey: "priceAnnual")
                default: break
                }
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
    }
        
    func setPrices() {
        retriveProductInfo(productID: monthlyProductID)
        retriveProductInfo(productID: annualProductID)
    }
        
    func purchaseProduct(productID: String, viewController: UIViewController) {
        vibrate(style: .medium)
        let view_loading = create_loading_view(view: viewController.view)
        viewController.view.addSubview(view_loading)
            
        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: false) { result in
                
            view_loading.removeFromSuperview()
                
            switch result {
            case .success(let purchase):
                    
                print("Purchase Success: \(purchase.productId)")
            
                DispatchQueue.main.async {
                    uDefaults.setValue(true, forKey: purchase.productId)
                    uDefaults.synchronize()
                }
                    
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                    self.verifySubscription(isComeFromRestore: false, viewController: viewController, completion: {})
                        
                    NotificationCenter.default.post(name: Notification.Name("present"), object: nil)
                }
                    
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
        
    func restorePurchase(viewController: UIViewController) {
        vibrate(style: .medium)
        let view_loading = create_loading_view(view: viewController.view)
        viewController.view.addSubview(view_loading)
            
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
                
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                    
                showAlert(title: NSLocalizedString("Can't Restored!", comment: ""), message: NSLocalizedString("Oh no!. We couldn't find any subscriptions in your account.", comment: ""), viewController: viewController, completion: {})
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                    
                for purchase in results.restoredPurchases {
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                    
                self.verifySubscription(isComeFromRestore: true, viewController: viewController, completion: {
                    if !self.isSubscribed() {
                        showAlert(title: NSLocalizedString("Can't Restored!", comment: ""), message: NSLocalizedString("Oh no!. We couldn't find any subscriptions in your account.", comment: ""), viewController: viewController, completion: {
                            NotificationCenter.default.post(name: Notification.Name("present"), object: nil)
                        })
                    }
                    view_loading.removeFromSuperview()
                })
            }
            else {
                print("Nothing to Restore")
                view_loading.removeFromSuperview()
                showAlert(title: NSLocalizedString("Can't Restored!", comment: ""), message: NSLocalizedString("Oh no!. We couldn't find any subscriptions in your account.", comment: ""), viewController: viewController, completion: {})
            }
        }
    }
        
    func verifySubscription(isComeFromRestore: Bool = false, viewController: UIViewController = inApp(), completion: @escaping () -> ()) {
        var checkedProductCount = 0
        for productID in arrAllProducts {
            if productID != "" {
                let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
                SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                    switch result {
                    case .success(let receipt):
                            
                        // Verify the purchase of a Subscription
                        let purchaseResult = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable, // or .nonRenewing (see below)
                            productId: productID,
                            inReceipt: receipt)
                            
                        switch purchaseResult {
                        case .purchased(let expiryDate, let items):
                            print("\(productID) is valid until \(expiryDate)\n\(items)\n")
                            // StoreKitOperations().isSubscribed() = true
                            uDefaults.setValue(true, forKey: productID)
                            uDefaults.synchronize()
                            checkedProductCount += 1
                            if isComeFromRestore {
                                NotificationCenter.default.post(name: Notification.Name("present"), object: nil)
                                completion()
                            }
   
                        case .expired(let expiryDate, let items):
                            print("\(productID) is expired since \(expiryDate)\n\(items)\n")
                            checkedProductCount += 1
                                
                            // StoreKitOperations().isSubscribed() = false
                            uDefaults.setValue(false, forKey: productID)
                            uDefaults.synchronize()
                            if checkedProductCount == arrAllProducts.count, isComeFromRestore {
                                completion()
                            }
                               
                        case .notPurchased:
                            print("The user has never purchased \(productID)")
                            checkedProductCount += 1
                                
                            // StoreKitOperations().isSubscribed() = false
                            uDefaults.setValue(false, forKey: productID)
                            uDefaults.synchronize()
                            if checkedProductCount == arrAllProducts.count, isComeFromRestore {
                                completion()
                            }
                        }
                            
                    case .error(let error):
                        print("Receipt verification failed: \(error)")
                    }
                }
            }
        }
    }
        
    func isPlanActive(_ plan: String) -> Bool {
        return uDefaults.bool(forKey: plan)
    }
        
    func isSubscribed() -> Bool {
        //  return true
        for productID in arrAllProducts {
            if isPlanActive(productID) {
                return true
            }
        }
        return false
    }
}
