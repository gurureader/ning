//
//  NingReceiptValidator.swift
//  ning
//
//  Created by tuicool on 2020/11/28.
//  Copyright © 2020 tuicool. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class NingReceiptValidator: ReceiptValidator {
    
    var transaction: PaymentTransaction?
    
    convenience init(_ transaction: PaymentTransaction) {
        self.init()
        self.transaction = transaction
    }

    func validate(receiptData: Data, completion: @escaping (VerifyReceiptResult) -> Void) {
        let encryptedReceipt = receiptData.base64EncodedString(options: [])
        logInfo("receipt=\(encryptedReceipt)")
        guard let order = DAOFactory.memberOrderDAO.getByTransactionId(transaction!.transactionIdentifier!) else {
            logError("not found order \(transaction!.transactionIdentifier!)")
            return
        }
        order.receipt_data = encryptedReceipt
        order.state = NingOrder.STATE_PAY_DONE
        DAOFactory.memberOrderDAO.update(item: order)
        //后端接口验证代码被删除
    }

}
