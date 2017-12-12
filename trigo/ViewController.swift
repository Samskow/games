//
//  ViewController.swift
//  trigo
//
//  Created by eleves on 17-11-13.
//  Copyright © 2017 eleves. All rights reserved.
//


import UIKit
import Foundation
import ImageIO
var arrayBonus = ["Boost X2        10💲":1,
                  "FREEZE 5s       50💲":2,
                  "SIZE BALL X2    100💲":3]

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayBonus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:nil)
        cell.textLabel?.text = [String](arrayBonus.keys)[indexPath.row]
        return cell
    }
    
    //-------BOUTIQUE------------
   
    
    @IBOutlet weak var boiteItem: UIView!
    @IBOutlet weak var light1: UIImageView!
    @IBOutlet weak var light2: UIImageView!
    @IBOutlet weak var balleDeFeu: UIImageView!
    
    //--------------------
    @IBOutlet weak var goal: UILabel!
    @IBOutlet weak var arret: UILabel!
    //---
    @IBOutlet weak var gardien: UIImageView!
    @IBOutlet weak var joueur: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var tirer: UIButton!
    @IBOutlet weak var balle: UIImageView!
    //-------TABLEAU---------
    @IBOutlet weak var boutique: UITableView!
    
    //-----------------------
    
    @IBOutlet weak var cage: UIImageView!
    
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
    var originalDefenseurGaucheX: CGFloat!
    var originalDefenseurGaucheY: CGFloat!
    @IBOutlet weak var defenseur2: UIImageView!
    var originalDefenseurDroiteX: CGFloat!
    var originalDefenseurDroiteY: CGFloat!
    @IBOutlet weak var defenseur3: UIImageView!
    var originalDefenseurGauche2X: CGFloat!
    var originalDefenseurGauche2Y: CGFloat!
    
    
    var cosdef: Double!
    var sindef: Double!
    var tempsDeDeplacement: Double!
    var defenseTimer:Timer!
    
    @IBOutlet weak var deco: UIView!
    //------------------------------------
    var degrees: Double!
    var cos: Double!
    var sin: Double!
    var aTimer: Timer!
    var distance = 0
    @IBOutlet weak var scoreLabel: UILabel!
    var score = 0
    var object_bounce: Bounce!
    
    @IBOutlet weak var mur_gauche: UIView!
    @IBOutlet weak var mur_haut: UIView!
    @IBOutlet weak var mur_droite: UIView!
    @IBOutlet weak var mur_bas: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        goalarret()
        //------OBJECT---------
        object_bounce = Bounce(ball: balle, left_window: mur_gauche, right_window: mur_droite, top_window: mur_haut, bottom_window: mur_bas,defenseur3 : defenseur3, defenseur: defenseur)
        //---------------------
        balleDeFeu.loadGif(name: "fireball")
        //balle.loadGif(name: "fireball")
        balle.image = UIImage(named: "canadianPuck")
        tirer.isEnabled = false
        tirer.alpha = 0.5
        placerBall()
        placerViseur()
        placerDefenseur()
        defendre()
        
        // Do any additional setup after loading the view, typically from a nib.
        boiteItem.layer.cornerRadius = 15
        deco.layer.cornerRadius = 20
        tirer.layer.cornerRadius = 50
        balle.layer.cornerRadius = 12.5
       
        //        balle.layer.borderColor = (UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 1.0) as! CGColor)
        balle.layer.borderWidth = 3
        //----point du viseur--------
        viseur.layer.cornerRadius = 7.5
        viseur2.layer.cornerRadius = 7.5
        viseur3.layer.cornerRadius = 7.5
        
        
        
    }
    //-----------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //-----ANIMATION GARDIEN et player
    func goalarret(){
        UIView.animate(withDuration: 1, animations: {
            
            self.gardien.frame.size.width += 10
            self.gardien.frame.size.height += 10
            
        }) { _ in
            UIView.animate(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations: {
                self.gardien.frame.origin.x -= 30
            })
        }
    }
    //----------------------
    
    
    @IBAction func animateBall(_ sender: UIButton) {
        
        placerBall()
        aTimer = Timer.scheduledTimer(timeInterval: 0.0025, target: self, selector: #selector(doAnimation), userInfo: nil, repeats: true)
        
        
    }
    @IBAction func rebond(_ sender: UIButton) {
        
        placerBall()
        aTimer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(doRebond), userInfo: nil, repeats: true)
        
        
    }
   @objc  func doAnimation(){
        //--- Desactivation  pour ne pas modifier la tracjectoire de la balle une fois lancer
        tirer.isEnabled = false
        tirer.alpha = 0.5
        slider.isEnabled = false
        slider.alpha = 0.5
        joueur.transform = CGAffineTransform(rotationAngle: -0.785398); //45 degree en radian par rapport à l'épaule droite du joueur
        //---
        distance += 1
        balle.center.x += CGFloat(cosv)
        balle.center.y += CGFloat(sinv)
        
        sinv = object_bounce.returnCosSinAfterTouch(sin: sinv, cos: cosv)[0]
        cosv = object_bounce.returnCosSinAfterTouch(sin: sinv, cos: cosv)[1]
        
        
        if distance >= 1000 {
            aTimer.invalidate()
            aTimer = nil
            placerBall()
            goal.isHidden = true
            //--- Reactivation  pour faire un nouveau lancer
            tirer.isEnabled = true
            tirer.alpha = 1
            slider.isEnabled = true
            slider.alpha = 1
            joueur.transform = CGAffineTransform(rotationAngle: 0);
            
        }
        //------COLLISION----------------
        if balle.frame.intersects(defenseur3.frame){
           
            arret.isHidden = false
            
            
        }
        
        if balle.frame.intersects(cage.frame){ // ----SCORE++------------
            score += 100
            scoreLabel.text = "Score : \(score)"
            print("GOAL!!!!")
            goal.isHidden = false
            aTimer.invalidate()
            aTimer = nil
            placerBall()
            tirer.isEnabled = true
            tirer.alpha = 1
            slider.isEnabled = true
            slider.alpha = 1
            
            light1.image = UIImage(named:"buzzerAllumé")
            light2.image = UIImage(named:"buzzerAllumé")
            
        }
        
        if balle.frame.intersects(gardien.frame){
            arret.isHidden = false
            balle.center.x -= CGFloat(cosv)
            balle.center.y -= CGFloat(sinv)
            
            
            
        }
    }
    
    //------------REBOND------------
  @objc func doRebond(){
        print("rebonddd")
        balle.center.x += 20
        balle.center.y += 20
        tirer.isEnabled = true
        tirer.alpha = 1
        slider.isEnabled = true
        slider.alpha = 1
        
        
    }
    
    //-------------------BALL---------------
    
    func placerBall(){
        
        light1.image = UIImage(named:"buzzer")
        light2.image = UIImage(named:"buzzer")
        balle.center.x = UIScreen.main.bounds.width / 2
        balle.center.y = UIScreen.main.bounds.height / 2
        distance = 0
        
    }
    //-----------------VISEUR----------------
    @IBAction func trajectoire(_ sender: UISlider) {
        tirer.isEnabled = true
        tirer.alpha = 1
        
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
        //-------defenseur1------------
        if defenseur.center.x < UIScreen.main.bounds.width {
            defenseur.center.x += 1
            defenseur.center.y += 0
        }else {
            
            defenseur.center.x = -1
            defenseur.center.y = UIScreen.main.bounds.height / 3
        }
        //-------defenseur2------------
        if defenseur2.center.x < UIScreen.main.bounds.width  {
            defenseur2.center.x -= 1
            defenseur2.center.y += 0
        }else {
            
            defenseur2.center.x = 500
            defenseur2.center.y = UIScreen.main.bounds.height / 4
        }
        //-------defenseur3-----------
        if defenseur3.center.x < UIScreen.main.bounds.width {
            defenseur3.center.x += 2
            defenseur3.center.y += 0
        }else {
            
            defenseur3.center.x = -1
            defenseur3.center.y = UIScreen.main.bounds.height / 4
        }
        
        //----------------------------
        
        
        
    }
    func placerDefenseur(){
        //-------defenseur1------------
        defenseur.center.x = UIScreen.main.bounds.width - 1
        defenseur.center.y = UIScreen.main.bounds.height / 3
        originalDefenseurGaucheX = viseur.center.x
        originalDefenseurGaucheY = viseur.center.y
        //-------defenseur2------------
        defenseur2.center.x = UIScreen.main.bounds.width - 1
        defenseur2.center.y = UIScreen.main.bounds.height / 4
        originalDefenseurDroiteX = viseur.center.x
        originalDefenseurDroiteY = viseur.center.y
        //-------defenseur3------------
        defenseur3.center.x = UIScreen.main.bounds.width - 1
        defenseur3.center.y = UIScreen.main.bounds.height / 4
        originalDefenseurGauche2X = viseur.center.x
        originalDefenseurGauche2Y = viseur.center.y
        //-------defenseur2------------
        
    }
    
    
    
    //------------------COLLISION---------------------------
    
    
    
    
    
    
}

