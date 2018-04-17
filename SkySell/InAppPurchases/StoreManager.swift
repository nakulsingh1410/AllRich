//
//  StoreManager.swift
//  InAppPurchases-Exercise
//
//  Created by Jad Habal on 2017-01-28.
//  Copyright © 2017 Jadhabal. All rights reserved.
//

import Foundation
import StoreKit

enum ProductType:String{
    
    case consumable
}


class StoreManager: NSObject {

    
    //Let's cearte a shared object so we can access our methods from anywhere in the app
    //Also this class should extend NSObject so we can make it as the delegate for our StoreKit
    
    /** This is a shared object of the StoreManager and you should only access their methods throgh the shared object */
    
    static var shared:StoreManager = {
       return StoreManager()
    }()
    
    
    
    //Let's create an array that will hold all our SKProducts receieved from the store after the request
    
    var productsFromStore = [SKProduct]()
    
    
    
    //Let's create an array to hold our productsID
    
    
    //Let's add our subscription id to all purchasable products for loading the product information
    var purchasableProductsIds:Set<String> = ["premium_plan","platinum_plan"] //For now we only have one product
    
    
    
    //We cloud have an array for every product type so we can check later
    
    let consumablesProductsIds:Set<String> = []//["super_credits_1000"]
    
    
    //let's create an array for non-consumables
    
    let nonConsumablesProductsIds:Set<String> = []//["com.swiftylab.unlock_backup_feature"];
    
    
    
    //let's create an array only for subscriptions
    var autoSubscriptionsIds:Set<String> = ["premium_plan","platinum_plan"]
    
    //Let's create our first call method 
    
    //Let's make our receipt manager class
    var receiptManager:ReceiptManager = ReceiptManager()
    
    func setup(){
        
        purchasableProductsIds.removeAll()
        autoSubscriptionsIds.removeAll()
        
        let myData:ShareData = ShareData.sharedInstance
        for p in myData.bufferAllPlans{
            let itune = p.itunes_id
            if(itune != ""){
                purchasableProductsIds.insert(itune)
                autoSubscriptionsIds.insert(itune)
            }
            
        }
        
        //In order to display the products for the user, the first thing we need to is to request our SKProduct from the store so we can show the product in our app and make it available for the user to purchase.
        
        
        //Let's load the products when we call the setup method
        
        //We should call our setup method when the app launches and the best place will be in AppDelegate
        
        self.requestProducts(ids: self.purchasableProductsIds)
        
        
        
        
        //We need to become the delegate for the SKPaymentTransaction
        
        SKPaymentQueue.default().add(self)
        
        
    }
    
    
    //Create a function load our products when the app launches and prepare them for us
    // 1- Request products by product id from the store
    func requestProducts(ids:Set<String>){
        
        //Before we make any payment we need to check if the user can make payments
        
        if SKPaymentQueue.canMakePayments(){
            
            //Create the request which we will send to Store
            //Note that we can request more than one preoduct at once
            let request = SKProductsRequest(productIdentifiers: ids)
            
            //Now we need to become the delegate for the Request so we can get responses
            request.delegate = self
            request.start()
            
            
        }else{
            
            print("User can't make payments from this account")
        }
        
    }
    
}


//Now in order to receive the calls you need to implement the delegate methods of SKProductsRequestDelegate

extension StoreManager:SKProductsRequestDelegate{
    
    
    //This method will be called when ever the request finished processing on the Store
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        //In the response there are the products SKProduct we requested in the request
        
        self.productsFromStore.removeAll()
        
        let products = response.products 
        
        if products.count > 0{
        
            //Loop through each product
            for product in products{
                
                //And add it to our array for later use
                self.productsFromStore.append(product)
            }
            
            
        }else{
            
            print("Products now found")
        }
        
        
        //Let's post a notification when our products have loaded so we can load them inside our tabelview
        NotificationCenter.default.post(name: NSNotification.Name.init("SKProductsHaveLoaded"), object: nil)
        
        
        
        
        //We can also check to see if we have sent wrong products ids
        
        let invalidProductsIDs = response.invalidProductIdentifiers
        
        for id in invalidProductsIDs{
            
            print("Wrong product id: ",id)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        
        print("error requesting products from the store",error.localizedDescription)
        
    }
    
    
    
    //Let's implement our buy method so we can pass it whatever SKProduct we want to purchase
    
    func buy(product:SKProduct){
        
        let payment = SKPayment(product: product)
        
        SKPaymentQueue.default().add(payment)
        
        print("Buying product: ",product.productIdentifier)
    }
    
    
    
    //Let's impelement the restore purchases method
    
    
    func restoreAllPurchases(){
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}



//We also need to implement the delegate methods for the SKPaymentTransactionObserver


extension StoreManager:SKPaymentTransactionObserver{
    
    //Two methods we will be interested in:
    
    
    //This mehtod will be called whenever there is an update from the store about a product or subscription etc...
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        //As you can see there are transactions and we need to loop through them in order to see what each transaction has for status
        
        for transaction in transactions{
            
            
            
            switch transaction.transactionState {
            case .purchased:
                self.purchaseCompleted(transaction: transaction)
            case .failed:
                self.purchaseFailed(transaction: transaction)
            case .restored:
                self.purchaseRestored(transaction: transaction)
            case .purchasing,.deferred:
                print("Pending")
                
            }
        }
        
        
        
    }
    
    //We will use it in future
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
       print("Restord finished processing all completed transactions")
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("Error restoring transactions",error.localizedDescription)
    }
    
    //Let's implement different function for each state
    
    func purchaseCompleted(transaction:SKPaymentTransaction){
        
        self.unlockContentForTransaction(trans: transaction)
        
        //Only after we have unlocked the content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
        
    }
    
    func purchaseFailed(transaction:SKPaymentTransaction){
        
        //In case of failed we need to check why it failed
        
        if let error = transaction.error as? SKError{
            
            switch error {
            case SKError.clientInvalid:
                print("User not allowed to make a payment request")
            case SKError.unknown:
                print("Unkown error while proccessing SKPayment")
            case SKError.paymentCancelled:
                print("User cancaled the payment request (Cancel)")
                
            case SKError.paymentInvalid:
                print("The purchase id was not valid")
                
            case SKError.paymentNotAllowed:
                print("This device is not allowed to make payments")
                
            default:
                break
            }
            
        }
        
        //Only after we have unlocked the content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
        
        
        NotificationCenter.default.post(name: NSNotification.Name.init("purchaseFailed"), object: nil)
    }
    
    func purchaseRestored(transaction:SKPaymentTransaction){
        
        self.unlockContentForTransaction(trans: transaction)
        
        //Only after we have unlocked the content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    
    
    //This function will unlock whatever the transaction have for product ID
    
    func unlockContentForTransaction(trans:SKPaymentTransaction){
        
        print("Should unlock the content for product ID",trans.payment.productIdentifier)
        
        
        //Now we need to implement whatever code required to unlock the content the user purchased
        
        
        //if Consumables
        if self.consumablesProductsIds.contains(trans.payment.productIdentifier){
            
            //If the product is 1000 credit sicen we can have more than one product
            if trans.payment.productIdentifier == "super_credits_1000"{
                
                    print("1000 credits has been added to your account")
            }
        }
        
        
        
        //if Non-Consumables
        if self.nonConsumablesProductsIds.contains(trans.payment.productIdentifier){
            
            //Here we should save the product id to UserDefaults so we can check later 
            self.savePurchasedProduct(id: trans.payment.productIdentifier)
            
            
            //Now we will post a notification so we can tell when the purchase process of Non-Consumable product is done so we can update our UI the table view and show Purchased instead of buy
            
            NotificationCenter.default.post(name: NSNotification.Name.init("DidPurchaseNonConsumableProductNotification"), object: nil, userInfo: ["id":trans.payment.productIdentifier])
            
        }
        
        
        //If subscription
        if self.autoSubscriptionsIds.contains(trans.payment.productIdentifier){
            
            //Now let's check our subscription since we only have one
            
            var receipt:Bool = false
            let myData:ShareData = ShareData.sharedInstance
            
            
            for id in myData.bufferAllPlans{
                if(trans.payment.productIdentifier == id.itunes_id){
                    receipt = true
                }
            }
            
            
            /*
            if trans.payment.productIdentifier == "com.pucknavin.MyIAP.sub.allaccess.monthly"{
                
             //User purchased this subscription
                
                //Now we need to tell the ReceiptManager to refresh the receipt so our app get updated with latest expires date of the subscription
                
                receiptManager.StartVaildatingReceipts()
                
            }
            */
            
            if(receipt == true){
                receiptManager.StartVaildatingReceipts()
            }
            
            
            
            
        }
        
    }
    
    
    
}





extension StoreManager{
    
    
    func savePurchasedProduct(id:String){
        
        //This way we save it as Bool value so we can if it has purchased or not
        UserDefaults.standard.set(true, forKey: id)
        
        
        //Usually it's saved inside a dictionary or an array but for since we dont have so many purchasble items this is fine for now
    }
    
    
    func isPurchased(id:String)->Bool{
        
        return UserDefaults.standard.bool(forKey: id)
    }
}











































