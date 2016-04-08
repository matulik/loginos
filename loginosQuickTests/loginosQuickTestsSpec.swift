//
//  loginosQuickTestsSpec.swift
//  loginos
//
//  Created by matulik on 07/04/16.
//  Copyright © 2016 matulik. All rights reserved.
//

import Quick
import Nimble
import XCTest

/* Scenario:
 1.
 Given app is start
 When I type correct username and password
 Then I see Login Successful screen
 
 2.
 Given app is start
 When I type incorrect username or password
 Then I see Error alert
 */

class loginosQuickTestsSpec: QuickSpec {
    var navigationController : UINavigationController!
    var visibleViewController: UIViewController! {
        get {
            return navigationController.visibleViewController
        }
    }
    var presentedViewController : AnyObject! {
        get {
            return navigationController.presentedViewController
        }
    }
    var topViewController : UIViewController! {
        get {
            return navigationController.topViewController
        }
    }
    
    
    override func spec() {
        
        // Why cany acces by self.viewController?
        func fillUsernameAndPassword(username name: String, password: String) {
            if let vc = navigationController.visibleViewController as? ViewController {
                vc.username.text = name
                vc.password.text = password
            }
        }
        
        func pressLoginButton() {
            let LOGIN_BUTTON_TAG = 1
            let loginButton: UIButton? = visibleViewController.view.viewWithTag(LOGIN_BUTTON_TAG) as? UIButton
            if let button = loginButton {
                button.sendActionsForControlEvents(.TouchUpInside)
            }
        }
        
        describe("Given app is started") {
            
            beforeEach {
                // Initialize application
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
                self.navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                UIApplication.sharedApplication().keyWindow!.rootViewController = self.navigationController
                //
                // Transitions
                self.topViewController.beginAppearanceTransition(true, animated: false)
                self.topViewController.endAppearanceTransition()
                //
            }
            
            afterEach {
                UIApplication.sharedApplication().keyWindow!.rootViewController = nil
            }
            
            describe("When I see login screen") {
                it("Then I Login with valid data") {
                    // Login screen is visible
                    expect(self.visibleViewController).notTo(beNil())
                    
                    fillUsernameAndPassword(username: "asd", password: "asd")
                    pressLoginButton()
                    
                    waitUntil(timeout: 5) { (done) in
                        NSThread.sleepForTimeInterval(1)
                        done()
                    }
                    expect(self.visibleViewController.restorationIdentifier).to(equal("LoginSuccessfullID"))
                }
            }
            
            describe("When I se login screen") {
                it("Then I Login with unvalid data") {
                    
                    expect(self.visibleViewController).notTo(beNil())
                    
                    fillUsernameAndPassword(username: "a", password: "a")
                    pressLoginButton()
                    
                    let errorAlert: UIAlertController? = self.presentedViewController as? UIAlertController
                    expect(errorAlert).notTo(beNil())
                    
                    expect(errorAlert?.message).to(contain("Try again"))
                }
            }
        }
    }
}

