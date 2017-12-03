//
//  ViewController.swift
//  trigo
//
//  Created by eleves on 17-11-13.
//  Copyright © 2017 eleves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tirer: UIButton!
    @IBOutlet weak var balle: UIView!
    
    @IBOutlet weak var angleField: UITextField!
    
    //----point du viseur--------
    @IBOutlet weak var viseur: UIView!
    var originalvX: CGFloat!
    var originalvY: CGFloat!
    var cosv: Double!
    var sinv: Double!
    @IBOutlet weak var viseur2: UIView!
    @IBOutlet weak var viseur3: UIView!
    //----------defenseur-----------------
 
    @IBOutlet weak var defenseur: UIImageView!
    var originaldefX: CGFloat!
    var originaldefY: CGFloat!
    var cosdef: Double!
    var sindef: Double!
    var tempsDeDeplacement: Double!
    var defenseTimer:Timer!
    
    //------------------------------------
    var degrees: Double!
    var cos: Double!
    var sin: Double!
    var aTimer: Timer!
    var distance = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placerBall()
        placerViseur()
        placerDefenseur()
        defendre()
        
        // Do any additional setup after loading the view, typically from a nib.
        tirer.layer.cornerRadius = 50
        balle.layer.cornerRadius = 12.5
        //----point du viseur--------
        viseur.layer.cornerRadius = 7.5
        viseur2.layer.cornerRadius = 7.5
        viseur3.layer.cornerRadius = 7.5
        //-------------------------------
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func animateBall(_ sender: UIButton) {
        placerBall()
        aTimer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(doAnimation), userInfo: nil, repeats: true)
        
        
    }
    func doAnimation(){
        distance += 1
        balle.center.x += CGFloat(cosv)
        balle.center.y += CGFloat(sinv)
        
        if distance >= 600 {
            aTimer.invalidate()
            aTimer = nil
            placerBall()
        }
        
    }
    
    //-------------------BALL---------------
    
    func placerBall(){
        
        balle.center.x = UIScreen.main.bounds.width / 2
        balle.center.y = UIScreen.main.bounds.height / 2
        distance = 0
    }
    //-----------------VISEUR----------------
    @IBAction func trajectoire(_ sender: UISlider) {
        let degreesv = sender.value
        cosv = __cospi(Double(degreesv/180))
        sinv = __sinpi(Double(degreesv/180))
        //-------
        viseur.center.x = originalvX + CGFloat(cosv * 20)
        viseur.center.y =  originalvY + CGFloat(sinv * 20)
        //-------
        viseur2.center.x = originalvX + CGFloat(cosv * 50)
        viseur2.center.y =  originalvY + CGFloat(sinv * 50)
        //-------
        viseur3.center.x = originalvX + CGFloat(cosv * 80)
        viseur3.center.y =  originalvY + CGFloat(sinv * 80)
        print(sender.value)
    }
    //-------
    func placerViseur(){
        viseur.center.x = UIScreen.main.bounds.width / 2
        viseur.center.y = UIScreen.main.bounds.height / 2
        
        //-----
        viseur2.center.x = UIScreen.main.bounds.width / 2
        viseur2.center.y = UIScreen.main.bounds.height / 2
        //------
        viseur3.center.x = UIScreen.main.bounds.width / 2
        viseur3.center.y = UIScreen.main.bounds.height / 2
        //------
        originalvX = viseur.center.x
        originalvY = viseur.center.y
    }
    //----------------------------------------
    
    
    
    
    
    //---------------DEFENSEUR---------------------------
    func defendre(){
        defenseTimer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(defenseAnimation), userInfo: nil, repeats: true)
    }
    
    func defenseAnimation(){
        if defenseur.center.x < UIScreen.main.bounds.width {
        defenseur.center.x += 1
        defenseur.center.y += 0
        }else {
            
            defenseur.center.x = -1
            defenseur.center.y = UIScreen.main.bounds.height / 3
        }
        
    }
    func placerDefenseur(){
        defenseur.center.x = UIScreen.main.bounds.width / 2
        defenseur.center.y = UIScreen.main.bounds.height / 3

        originaldefX = viseur.center.x
        originaldefY = viseur.center.y
        
    }
    
    
    
    //---------------------------------------------
    
    
    
    
    
    
}

