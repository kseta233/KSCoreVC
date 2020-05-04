//
//  UIScreen+Extension.swift
//  KSCore
//
//  Created by Avows MBP on 04/05/20.
//

import UIKit


extension UIScreen {
    
    func getDeviceHeight() -> CGFloat {
        return self.bounds.size.height
    }
    
    func getDeviceWidth() -> CGFloat {
        return self.bounds.size.width
    }
    
    func getHigherHeight() -> CGFloat {
        return (self.getDeviceWidth() > self.getDeviceHeight()) ? self.getDeviceWidth() : self.getDeviceHeight()
    }
}


