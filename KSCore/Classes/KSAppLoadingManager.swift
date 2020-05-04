//
//  KSAppLoadingManager.swift
//  KSCore
//
//  Created by Avows MBP on 04/05/20.
//

import Foundation


class KSAppLoadingManager: NSObject {
    static let sharedInstance:KSAppLoadingManager = KSAppLoadingManager()
    
//    var loading: MBProgressHUD?
    
    @objc public func showLoading (view: UIView) {
//        self.loading = MBProgressHUD.showAdded(to: view, animated: true)
//        loading?.mode = MBProgressHUDMode.indeterminate
//        loading?.label.text = "Loading"
    }
    
    @objc public func dismissLoading(){
//        loading?.hide(animated: true)
    }
    
}
