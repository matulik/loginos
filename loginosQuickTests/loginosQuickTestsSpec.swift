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
    var viewController: ViewController!
    
    override func spec() {
        var viewController : ViewController!
        var navigationController : UINavigationController!
        
        // Why cany acces by self.viewController?
        func fillUsernameAndPassword(username name: String, password: String) {
            if let vc = navigationController.visibleViewController as? ViewController {
                vc.username.text = name
                vc.password.text = password
            }
        }
        
        func pressLoginButton() {
            let LOGIN_BUTTON_TAG = 1
            let loginButton: UIButton? = navigationController.visibleViewController?.view.viewWithTag(LOGIN_BUTTON_TAG) as? UIButton
            if let button = loginButton {
                button.sendActionsForControlEvents(.TouchUpInside)
            }
        }
        
        beforeEach {
            // Initialize application
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
            navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            viewController = navigationController.topViewController as! ViewController
            UIApplication.sharedApplication().keyWindow!.rootViewController = navigationController
            //
        }
        
        describe(".viewDidLoad()") {
            beforeEach {
                _ = viewController.view
                _ = navigationController.view
            }
        }
        
        describe("App is started") {
            beforeEach {
                viewController.beginAppearanceTransition(true, animated: false)
                viewController.endAppearanceTransition()
            }
            
            context("Login test") {
                it("Login with valid data") {
                    
                    // Login screen is visible
                    let loginVC: ViewController? = navigationController?.visibleViewController as? ViewController
                    expect(loginVC).notTo(beNil())
                    
                    // Login with valid data
                    fillUsernameAndPassword(username: "asd", password: "asd")
                    pressLoginButton()
                    
                    // Wait for transition
                    waitUntil(timeout: 5) { (done) in
                        
                        // Transition logic check
                        //// Why not topViewController?
                        let loginSuccessFullVC: UIViewController? = navigationController?.visibleViewController
                        expect(loginSuccessFullVC).notTo(beNil())
                        if let loggedVC = loginSuccessFullVC {
                            // LoginSuccessfull screen is visible
                            expect(loggedVC.restorationIdentifier).to(equal("LoginSuccessfullID"))
                        }
                        //
                        
                        // Repeat every 1 sec
                        NSThread.sleepForTimeInterval(1)
                        done()
                    }
                }
                
                it("Login with unvalid data") {
                    
                    // Login screen is visible
                    let loginVC: ViewController? = navigationController?.visibleViewController as? ViewController
                    expect(loginVC).notTo(beNil())
                    
                    // Login with unvalid data
                    fillUsernameAndPassword(username: "a", password: "a")
                    pressLoginButton()
                    
                    let errorAlert: UIAlertController? = navigationController.presentedViewController as? UIAlertController
                    // Alert is visible
                    expect(errorAlert).notTo(beNil())
                    
                    if let alert = errorAlert {
                        // Alert message is "Try again"
                        expect(alert.message).to(contain("Try again"))
                    }
                    
                }
            }
        }
    }
}
