//
//  WebPreviewVC.swift
//  NgeeAnnPoly
//
//  Created by DW02 on 11/15/2559 BE.
//  Copyright © 2559 DW02. All rights reserved.
//

import UIKit

class WebPreviewVC: UIViewController {

    
    @IBOutlet weak var viHeaderBG: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btBack: UIButton!
    
    
    
    @IBOutlet weak var myWeb: UIWebView!
    
    @IBOutlet weak var viToolBar: UIView!
    
    
    @IBOutlet weak var btWeb_Back: UIButton!
    
    @IBOutlet weak var btWeb_Next: UIButton!
    
    @IBOutlet weak var btWeb_Reload: UIButton!
    @IBOutlet weak var btWeb_Share: UIButton!
    
    
    @IBOutlet weak var layOutToolbarButtom: NSLayoutConstraint!
    
    
    @IBOutlet weak var viActivity: UIView!
    
    
    
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    var haveNoti:Bool = false
    
    var strURL:String = ""
    
    var strTitle:String = ""
    
    var lastY:CGFloat = 0
    var working:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        
        lbTitle.text = strTitle
        
        
        lbTitle.numberOfLines = 2
        //lbTitle.adjustsFontSizeToFitWidth = true
       // lbTitle.minimumScaleFactor = 0.5
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        
        
        viHeaderBG.layer.shadowOffset = CGSize(width: 0, height: 1)
        viHeaderBG.layer.shadowRadius = 4
        viHeaderBG.layer.shadowColor = UIColor(red: (153/255), green: (153/255), blue: (153/255), alpha: 1.0).cgColor
        viHeaderBG.layer.shadowOpacity = 0.33
        
        
        print(strURL)
        
        self.myWeb.delegate = self
        self.myWeb.scrollView.delegate = self
        let url:URL? = URL(string: strURL)
        
        if let url = url{
            let request:URLRequest = URLRequest(url: url)
            
            self.myWeb.loadRequest(request)
        }else{
            
            
            
            let seconds = 0.950
            let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                
                let alertControllerNeedUpdate = UIAlertController(title: "Can't Connect to Server.", message: nil, preferredStyle: .alert)
                
                
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    
                    
                    
                }
                
                alertControllerNeedUpdate.addAction(cancelAction)
                self.present(alertControllerNeedUpdate, animated: true, completion: nil)
                
            }
            
            
            
            
            
            let searchWord1:String = strURL.replacingOccurrences(of: " ", with: "+")
            let searchWord:String = searchWord1.replacingOccurrences(of: "http://", with: "")
            let search:String = String(format: "https://www.bing.com/search?q=%@", searchWord)
            let urls:URL? = URL(string: search)
            
            
            if let urls = urls{
                let request:URLRequest = URLRequest(url: urls)
                
                self.myWeb.loadRequest(request)
            }
        }
        
        
        
        
        
        self.layOutToolbarButtom.constant = -40
        self.viToolBar.alpha = 0
        self.viToolBar.isUserInteractionEnabled = false
        
        self.view.bringSubview(toFront: viHeaderBG)
        
        
        self.btWeb_Back.isEnabled = false
        self.btWeb_Next.isEnabled = false
        
        
        self.viActivity.clipsToBounds = true
        self.viActivity.layer.cornerRadius = 5.0
        
        
        self.viActivity.isUserInteractionEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateFrame()
        
        if(haveNoti == false){
            haveNoti = true
            NotificationCenter.default.addObserver(self, selector: #selector(WebPreviewVC.orientationChanged(notification:)), name:NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
            
            
            
        }
        
     
        
        let seconds = 0.950
        let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            self.hidenActivity()
            
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if(haveNoti == true){
            haveNoti = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
            
        }
        
        
        
        
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - RotageView
    func orientationChanged(notification:NSNotification){
        self.adjustViewsForOrientation(orientation: UIApplication.shared.statusBarOrientation, Animate: false)
    }
    
    func adjustViewsForOrientation(orientation:UIInterfaceOrientation, Animate animate:Bool){
        
        
        
        switch(orientation){
        case .portrait, .portraitUpsideDown:
            break
            
            
        case .landscapeLeft, .landscapeRight:
            break
        default:
            break
            
        }
        
        screenSize = UIScreen.main.bounds
        updateFrame()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            break
        case .pad:
            // It's an iPad
            
            
            let seconds = 0.20
            
            
            let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                self.updateFrame()
            }
            
            
            
            break
        case .unspecified:
            // Uh, oh! What could it be?
            break
        default:
            break
        }
    }
    
    
    func updateFrame() {
        
        self.screenSize = UIScreen.main.bounds
     
        if(self.screenSize.width <= 320){
            lbTitle.font = UIFont(name: "OpenSans-Semibold", size: 16)
            
        }else if(self.screenSize.width <= 375){
            lbTitle.font = UIFont(name: "OpenSans-Semibold", size: 20)
        }else{
            lbTitle.font = UIFont(name: "OpenSans-Semibold", size: 24)
        }
        
    }
    
    
    
    // MARK: - Action
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        
        if let navigation = self.navigationController{
            navigation.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    
    
    @IBAction func tapOnWebBlack(_ sender: UIButton) {
        self.myWeb.goBack()
    }
    
    
    @IBAction func tapOnWebNext(_ sender: UIButton) {
        self.myWeb.goForward()
    }

    
    @IBAction func tapOnWebReload(_ sender: UIButton) {
        myWeb.reload()
        
    }
    
    
    
    @IBAction func tapOnWebShare(_ sender: UIButton) {
    
        let strText:String = self.strURL
        
        
        
        //let imageShare:UIImage = UIImage(named: "shareImage.png")!
        
        
        
        
        
        
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            let activityController:UIActivityViewController = UIActivityViewController(activityItems: [ strText], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
            break
        case .pad:
            // It's an iPad
            
            let activityController:UIActivityViewController = UIActivityViewController(activityItems: [ strText], applicationActivities: nil)
            
            
        
            
            
            activityController.popoverPresentationController?.sourceView = self.viToolBar
            
            activityController.popoverPresentationController?.sourceRect = self.btWeb_Share.frame
            
            
            self.present(activityController, animated: true, completion: nil)
            break
        case .unspecified:
            // Uh, oh! What could it be?
            break
        default:
            break
        }
    }
    
    
    
    func showActivity() {
        
        UIView.animate(withDuration: 0.45, animations: { _ in
            self.viActivity.alpha = 1
            
        })
        
    }
    
    func hidenActivity() {
        UIView.animate(withDuration: 0.45, animations: { _ in
            self.viActivity.alpha = 0
            
        })
    }
}

extension WebPreviewVC:UIWebViewDelegate, UIScrollViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if(self.myWeb.canGoBack){
            self.btWeb_Back.isEnabled = true
        }else{
            self.btWeb_Back.isEnabled = false
        }
        
        
        if(self.myWeb.canGoForward){
            self.btWeb_Next.isEnabled = true
        }else{
            self.btWeb_Next.isEnabled = false
        }
        
        
        return true
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        //self.showActivity()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hidenActivity()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.hidenActivity()
        
        /*
        let alertControllerNeedUpdate = UIAlertController(title: "Can't Connect to Server.", message: nil, preferredStyle: .alert)
        
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            
            
            
        }
        
        alertControllerNeedUpdate.addAction(cancelAction)
        self.present(alertControllerNeedUpdate, animated: true, completion: nil)
 */
    }
    
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var newY:CGFloat = 0
        if(scrollView.contentOffset.y > lastY){
            newY = -40
            self.viToolBar.isUserInteractionEnabled = false
        }else{
            newY = 0
            self.viToolBar.isUserInteractionEnabled = true
        }
        lastY = scrollView.contentOffset.y
        if(scrollView.contentOffset.y < 0){
            lastY = 0
            newY = 0
            self.viToolBar.isUserInteractionEnabled = true
        }
        
        
       
        
        
        if((self.working == false) && (self.layOutToolbarButtom.constant != newY) ){
            self.working = true
            
            self.layOutToolbarButtom.constant = newY
            UIView.animate(withDuration: 0.45, animations: {
                
                if(newY == -40){
                    self.viToolBar.alpha = 0
                }else{
                    self.viToolBar.alpha = 1
                }
                self.view.updateConstraints()
                self.view.layoutIfNeeded()
                
                
            }, completion: { (finish) in
                self.working = false
                
            })
            
        }
    }
    
}
