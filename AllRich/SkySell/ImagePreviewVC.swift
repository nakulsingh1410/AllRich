//
//  ImagePreviewVC.swift
//  DemoHome
//
//  Created by supapon pucknavin on 10/22/2559 BE.
//  Copyright © 2559 DW02. All rights reserved.
//

import UIKit

class ImagePreviewVC: UIViewController {

    @IBOutlet weak var viTopBar: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var layout_TopBar_Top: NSLayoutConstraint!
    @IBOutlet weak var btBack: UIButton!
    
    @IBOutlet weak var btDelete: UIButton!
    @IBOutlet weak var viContentBG: UIView!
    
    
    var strTitle:String = "DIRECTHOME"
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    var haveNoti:Bool = false
    
    @IBOutlet weak var myPageControll: UIPageControl!
    
    @IBOutlet weak var layout_PageControll_Bottom: NSLayoutConstraint!
    
    
    
    
    
    
    
    var myPageViewController:UIPageViewController! = nil
    
    
    
    var arImageName:[PostImageObject] = [PostImageObject]()
    var currentPage:NSInteger = 0
    
    
    var working:Bool = false
    var showMenuBar:Bool = true
    
    
    var isEditMode:Bool = false
    
  
    var callBackDelete:(NSInteger)->Void = { (imageIndex) in }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viTopBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.viTopBar.layer.shadowOpacity = 0.05
        self.viTopBar.layer.shadowRadius = 1
        
        self.viTopBar.clipsToBounds = false
        
        
        self.lbTitle.text = strTitle
        
        self.myPageControll.numberOfPages = arImageName.count
        self.myPageControll.currentPage = self.currentPage
    
        self.viContentBG.clipsToBounds = true
        if(self.myPageViewController == nil){
            
            let firstVC = self.viewControllerAtIndex(index: self.currentPage)
          
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
         
            self.myPageViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
            
            
            //UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: [:])
            
            self.myPageViewController.setViewControllers([firstVC!], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: { (finish) in
                
               
                
            })
            self.myPageViewController.dataSource = self
            self.myPageViewController.delegate = self
            self.myPageViewController.view.frame = CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height + 40)
            
            
            self.addChildViewController(self.myPageViewController)
            self.viContentBG.addSubview(self.myPageViewController.view)
            self.myPageViewController.didMove(toParentViewController: self)
            
        }
        
      
        self.viContentBG.alpha = 0
        
        
        if(self.isEditMode == false){
            self.btDelete.alpha = 0
            self.btDelete.isEnabled = false
        }else{
            self.btDelete.alpha = 1
            self.btDelete.isEnabled = true
        }
     
    }

    override func viewWillAppear(_ animated: Bool) {
        self.updateFrame()
        
        if(haveNoti == false){
            haveNoti = true
            NotificationCenter.default.addObserver(self, selector: #selector(ImagePreviewVC.orientationChanged(notification:)), name:NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
         
            NotificationCenter.default.addObserver(self, selector: #selector(ImagePreviewVC.reciveNotiTap(notification:)), name:NSNotification.Name(rawValue: "tapForOpenTopBar"), object: nil)
            
        }
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateFrame()
        
        UIView.animate(withDuration: 0.45) { 
            self.viContentBG.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(haveNoti == true){
            haveNoti = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "tapForOpenTopBar"), object: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
        self.myPageViewController.view.frame = CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height + 40)// + 40
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
    
    
    
    func viewControllerAtIndex(index:NSInteger) -> PanViewController? {
    
        
        if((index >= 0) && (index < self.arImageName.count)){
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:PanViewController = storyboard.instantiateViewController(withIdentifier: "PanViewController") as! PanViewController
            
            
            let imObj = self.arImageName[index]
            
            if(imObj.image_src.count > 5){
                vc.strImageName = imObj.image_src
                vc.isURLImage = true
            }else{
                vc.localImage = imObj.local_image
                vc.isURLImage = false
            }
            
            
            vc.pageIndex = index
            
            
            
            
            return vc
        }else{
            return nil
        }
        
        
    }
    
    
    func showMenuBar(show:Bool) {
        
        if(working == false){
            working = true
            self.showMenuBar = show
            if(show == false){
             
                self.viTopBar.isUserInteractionEnabled = false
                self.layout_TopBar_Top.constant = -75
                self.layout_PageControll_Bottom.constant = -37
                
                for view in self.myPageViewController.view.subviews{
                    if let scroll = view as? UIScrollView{
                        scroll.isScrollEnabled = false
                    }
                }
                
  
                UIView.animate(withDuration: 0.45, animations: { 
                    self.viTopBar.alpha = 0
                    self.myPageControll.alpha = 0
                    self.view.layoutIfNeeded()
                    self.view.updateConstraints()
                    
                    }, completion: { (finish) in
                        self.working = false
                        
                        let object:[String:Bool] = ["enable": true]
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EnablePanImagePanView"), object: nil, userInfo: object)
                })
            }else{
                self.layout_TopBar_Top.constant = 0
                self.layout_PageControll_Bottom.constant = 8
            
                
                for view in self.myPageViewController.view.subviews{
                    if let scroll = view as? UIScrollView{
                        scroll.isScrollEnabled = true
                    }
                }
                
                
                UIView.animate(withDuration: 0.45, animations: {
                    self.viTopBar.alpha = 1
                    self.myPageControll.alpha = 1
                    
                    self.view.layoutIfNeeded()
                    self.view.updateConstraints()
                    
                    }, completion: { (finish) in
                        self.working = false
                        self.viTopBar.isUserInteractionEnabled = true
                        let object:[String:Bool] = ["enable": false]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EnablePanImagePanView"), object: nil, userInfo: object)
                })
            }
        }
        
    }
    
    @IBAction func tapOnDelete(_ sender: UIButton) {
        
        
        
        
        
        let alertController = UIAlertController(title: "Remove image", message: "Are you sure you want to remove this image?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancle", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        
        let okAction = UIAlertAction(title: "Remove", style: .default) { (action) in
            
            //var save:Bool = true
            
            self.callBackDelete(self.currentPage)
            
            
            if let navigation = self.navigationController{
                navigation.popViewController(animated: true)
            }else{
                self.dismiss(animated: true, completion: {
                    
                })
            }
            
        }
        alertController.addAction(okAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    func reciveNotiTap(notification:NSNotification){
        
        self.showMenuBar(show: !self.showMenuBar)
        
    }
    
    
    func postChangeImagePage()  {
        self.myPageControll.currentPage = self.currentPage
    }
    
    
    
}

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension ImagePreviewVC:UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    
  
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var next = self.currentPage
        
        
        if(self.arImageName.count <= 1){
            return nil
            
        }
        if let vc = viewController as? PanViewController{
            next = vc.pageIndex
        }else{
            return nil
        }
        
        
        self.currentPage -= 1
        if(self.currentPage < 0){
            self.currentPage = self.arImageName.count - 1
        }
        self.postChangeImagePage()
        
        next -= 1
        if(next < 0){
            next = self.arImageName.count - 1
        }
        return self.viewControllerAtIndex(index: next)
        
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var next = self.currentPage
        if(self.arImageName.count <= 1){
            return nil
            
        }
        
        if let vc = viewController as? PanViewController{
            next = vc.pageIndex
        }else{
            return nil
        }
        
        
        self.currentPage += 1
        if(self.currentPage >= self.arImageName.count){
            self.currentPage = 0
        }
        
        self.postChangeImagePage()
        next += 1
        if(next >= self.arImageName.count){
            next = 0
        }
        return self.viewControllerAtIndex(index: next)
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.arImageName.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentPage
    }
    
  
    
}

