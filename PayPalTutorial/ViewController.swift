//
//  ViewController.swift
//  PayPalTutorial
//
//  Created by Tommy Ryanto on 26/09/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PayPalPaymentDelegate {
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("canceled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("success")
        paymentViewController.dismiss(animated: true) {
            print("This is the payment \(completedPayment.confirmation)")
        }
    }
    
    @IBAction func payButton(_ sender: Any) {
        let item1 = PayPalItem(name: "iPhone 11 Pro Max 256", withQuantity: 1, withPrice: NSDecimalNumber(string: "1099.0"), withCurrency: "USD", withSku: "TomCorp-0001")
        let subtotal = PayPalItem.totalPrice(forItems: [item1])
        
        //optional
        let shipping = NSDecimalNumber(string: "10.0")
        let tax = NSDecimalNumber(string: "30.0")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "PaymentForiPhone", intent: .sale)
        
        payment.items = [item1]
        payment.paymentDetails = paymentDetails
        if payment.processable {
            let paymentVC = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            self.present(paymentVC!, animated: true) {
                
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration()
    var environment: String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if newEnvironment != environment {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var acceptCreditCards: Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        payPalConfig.acceptCreditCards = acceptCreditCards
        payPalConfig.merchantName = "Tommy R Corp."
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.google.com/")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.apple.com/")
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal
        PayPalMobile.preconnect(withEnvironment: environment)
    }


}

