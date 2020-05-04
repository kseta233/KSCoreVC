//
//  KSCoreViewController.swift
//  KSCore
//
//  Created by Avows MBP on 04/05/20.
//

import Foundation
import UIKit

@objc public protocol KSCoreViewControllerDelegate {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
    func onViewWillDissapear()
}

open class KSCoreViewController: UIViewController {
    weak var coreVCDelegate: KSCoreViewControllerDelegate?
    open var coordinator: KSMainCoordinator?
    public var navigationHidden: Bool = false
    public var navigationBackButtonColor: UIColor = UIColor.white
    public var navigationBarColor: UIColor = UIColor.red
    public var  navigationTitleBarColor : UIColor = UIColor.white

    lazy var cvm : KSCoreViewModel = {
        return KSCoreViewModel()
    }()
    
    let labelNoData: UILabel = {
        let label: UILabel = UILabel()
        label.text = "NO DATA, tap to refresh"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // used for table view related refresh control
    var refreshControl: UIRefreshControl!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        superSetup()
        setupViewModel()
        setupLayout()
        //hack the darkmode
        if #available(iOS 13.0, *) {
            self.view.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        self.setupNavigationBackButtonColor(self.navigationBackButtonColor)
        self.setupNavigationBarColor(self.navigationBarColor, titleColor: self.navigationTitleBarColor)
//        self.labelNoData.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPullToRefresh)))
        coreVCDelegate?.onViewDidLoad()
        
        //setup nodata label
        self.view.addSubview(self.labelNoData)
        self.labelNoData.anchorCenterSuperview()
        self.setupObserver()
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(navigationHidden, animated: true)
        
        coreVCDelegate?.onViewWillAppear()
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        coreVCDelegate?.onViewDidAppear()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(navigationHidden, animated: true)
        coreVCDelegate?.onViewWillDissapear()
    }
    
    
    
    fileprivate func setupObserver(){
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.stopLoading, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.startLoading, object: nil)
//        NotificationCenter.default.addObserver(self,selector: #selector(self.onReceiveShouldStopLoading(notification:)), name: NSNotification.Name.stopLoading, object: nil)
//        NotificationCenter.default.addObserver(self,selector: #selector(self.onReceiveShouldStopLoading(notification:)), name: NSNotification.Name.stopLoading, object: nil)
    }
    
    @objc func onReceiveShouldStartLoading(notification: Notification){
        self.showLoading()
    }
    @objc func onReceiveShouldStopLoading(notification: Notification){
        self.dismissLoading()
    }
    
    
    // this function is to be overwritten in child, will done first time
    open func superSetup(){}
    open func setupLayout(){}
    
    // background
    func setupBackground(withImage imageName: String, orColor: UIColor) {
        if imageName == "" {self.view.backgroundColor = orColor}
        else{
            let tag = 133
            if let img = UIImage(named: imageName) {
                if let bgView = view.viewWithTag(tag) {
                    bgView.removeFromSuperview()
                    
                }
                let bgImageView = UIImageView()
                let width = UIScreen.main.getDeviceWidth()
                let height = UIScreen.main.getDeviceHeight()
                bgImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                bgImageView.image = img
                bgImageView.contentMode = .scaleAspectFill
                bgImageView.tag = tag
                view.addSubview(bgImageView)
                view.sendSubviewToBack(bgImageView)
                
            }else{
                if #available(iOS 13.0, *) {
                    self.view.backgroundColor = UIColor.systemGroupedBackground
                } else {
                    // Fallback on earlier versions
                    self.view.backgroundColor = UIColor.groupTableViewBackground
                }
            }
        }
    }
    
    func setupNavigationBackButtonColor(_ color:UIColor){
        self.navigationController?.navigationBar.tintColor = color
    }
    
    func setupNavigationTitleColor(_ color: UIColor) {
        self.coordinator?.navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
//        self.coordinator?.navigationController.navigationBar.tintColor = color
        
    }
    func setupNavigationBarColor(_ color: UIColor, titleColor: UIColor) {
        if color == UIColor.clear {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        }
        else{
            navigationController?.navigationBar.barTintColor = color
            navigationController?.navigationBar.isTranslucent = false
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: titleColor,
//            NSAttributedString.Key.font: AppFont.fontTitle
        ]
    }
    
    open func setupViewModel() {
        cvm.onIsLoadingChanged = {
            [weak self]() in DispatchQueue.main.async {
                if let isLoading = self?.cvm.isLoading {
                    if isLoading {
                        self?.showLoading()
                    }
                    else {
                        self?.dismissLoading()
                    }
                }
            }
        }
        cvm.onAlertMessageChanged = {
            [weak self]() in DispatchQueue.main.async {
                if let alertMessage = self?.cvm.alertMessage {
                    if alertMessage != "" {
                        self?.showBanner(message: alertMessage, style: self?.cvm.getCurrentBannerType() ?? .info)
                    }
                }
            }
        }
    }
    
    func showBanner(title: String, message: String, style : KSAlertType) {
        KSAlertView.alert(title: title, message: message, style: style)
    }
    
    fileprivate func showBanner(message: String, style : KSAlertType) {
        self.showBanner(title: "", message: message, style: style)
    }
    
    fileprivate func showLoading(){
        KSAppLoadingManager.sharedInstance.showLoading(view: self.view)
    }
    fileprivate func dismissLoading(){
        KSAppLoadingManager.sharedInstance.dismissLoading()
    }
    
    func handleCall(strName: String) {
        if let url = URL(string: "tel://\(strName)") {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:]) { (b) in
                        
                    }
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
            else {
                self.cvm.alertMessage = "can't do phone call"
            }
        }
        else {
            self.cvm.alertMessage = "can't do phone call"
        }
    }
    
    //for setuptableview
    func setupTableView(tableView: UITableView, withRefreshControl: Bool){
        //setup tableview
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableHeaderView?.isHidden = true
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        if withRefreshControl {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: UIControl.Event.valueChanged)
            tableView.addSubview(refreshControl)
        }
    }
    
    //to be overwrite
    @objc func onPullToRefresh() -> Void {
        self.refreshControl.endRefreshing()
    }
    
    func showOfflinePage(){
        // TODO popup or something?
    }
}
extension KSCoreViewController : KSCoreCustomInit {

}
