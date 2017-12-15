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


class ViewController: UIViewController {
    
    
    //-------BOUTIQUE------------
    
    
    @IBOutlet weak var boiteItem: UIView!
    @IBOutlet weak var light1: UIImageView!
    @IBOutlet weak var light2: UIImageView!
    
    //--------BOUTON DE CHOIX D'ITEM ----------
    
    @IBOutlet weak var boutonChoix1: UIButton!
    
    @IBOutlet weak var boutonChoix2: UIButton!
    
    @IBOutlet weak var boutonChoix3: UIButton!
    
    @IBOutlet weak var boutonChoix4: UIButton!
    
    //-----CADENAS--------
    //---item1---
    @IBOutlet weak var locketat1: UIImageView!
    @IBOutlet weak var balleDeFeu: UIImageView!
    
    //---item2---
    @IBOutlet weak var locketat2: UIImageView!
    
    @IBOutlet weak var oilers: UIImageView!
    //---item3---
    @IBOutlet weak var locketat3: UIImageView!
    @IBOutlet weak var canadien: UIImageView!
    
    //---item4---
    @IBOutlet weak var locketat4: UIImageView!
    
    @IBOutlet weak var toronto: UIImageView!
    
    
    //--------------------
    @IBOutlet weak var goal: UILabel!
    //---
    @IBOutlet weak var gardien: UIImageView!
    @IBOutlet weak var joueur: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var tirer: UIButton!
    @IBOutlet weak var balle: UIImageView!
    //-------TABLEAU---------
    @IBOutlet weak var boutique: UITableView!
    
    //----------POTEAU DROIT--------------
    @IBOutlet weak var PoteauDroit: UIView!
    
    //----------POTEAU GAUCHE-------------
    @IBOutlet weak var PoteauGauche: UIView!
    
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
    
    @IBOutlet weak var cliquez_pour_ajouter: UILabel!
    
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
        cliquez_pour_ajouter.isHidden = true
        resetDesItems()
        balleDeFeu.loadGif(name: "fireball")
        goalarret()
        //------OBJECT---------
        object_bounce = Bounce(ball: balle, left_window: mur_gauche, right_window: mur_droite, top_window: mur_haut, bottom_window: mur_bas,defenseur3 : defenseur3, defenseur: defenseur,PoteauGauche: PoteauGauche,
                               PoteauDroit: PoteauDroit)
        //---------------------
        
        balle.image = UIImage(named: "ballParDefaut")
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
            
            
        }
        
        if balle.frame.intersects(cage.frame){ // ----SCORE++------------
            score += 100
            //------------UNLOCK--------
            if score >= 100{
                locketat4.image = UIImage(named: "unlock")
                toronto.alpha = 1.0
                cliquez_pour_ajouter.isHidden = false
                
            }
            if score >= 300{
                locketat3.image = UIImage(named: "unlock")
                canadien.alpha = 1.0
            }
            if score >= 500{
                locketat2.image = UIImage(named: "unlock")
                oilers.alpha = 1.0
            }
            if score >= 700{
                locketat1.image = UIImage(named: "unlock")
                balleDeFeu.alpha = 1.0
            }
            
            //----------------------------
            
            
            
            scoreLabel.text = "Score : \(score)"
            print("GOAL!!!!")
            goal.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {// attente de 3 sec avant de faire disparaitre le label goal
                self.goal.isHidden = true
            }
            aTimer.invalidate()
            aTimer = nil
            placerBall()
            tirer.isEnabled = true
            tirer.alpha = 1
            slider.isEnabled = true
            slider.alpha = 1
            
            //*************** ANIMATION SCORE ++ *****************
            
            goal.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 1.7,
                           delay: 0.8,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.goal.transform = .identity
            }, completion: nil)
            //****************************************************
            
            light1.image = UIImage(named:"buzzerAllumé")
            light2.image = UIImage(named:"buzzerAllumé")
            
            //*************** ANIMATION BUZZER *****************
            light1.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 1.7,
                           delay: 0.8,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.light1.transform = .identity
            }, completion: nil)
            
            light2.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 1.7,
                           delay: 0.8,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.light2.transform = .identity
            }, completion: nil)
            //****************************************************
        }
        
        if balle.frame.intersects(gardien.frame){
           
            
            balle.center.x -= CGFloat(cosv)// pour que le gardien garde le palet
            balle.center.y -= CGFloat(sinv)
            
            
            
            
        }
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
    
    //===========================================================
    //================= CHOIX ITEM ==============================
    
    @IBAction func choix1Action(_ sender: UIButton) {
        if score >= 700 {
            // balle.image = UIImage(named: "fireball")
            //balleDeFeu.loadGif(name: "fireball")
            balle.loadGif(name: "fireball")
        }
    }
    
    @IBAction func choix2Action(_ sender: UIButton) {
        if score >= 500 {
            balle.image = UIImage(named: "oilersPuck")
        }
    }
    
    @IBAction func choix3Action(_ sender: UIButton) {
        if score >= 300 {
            balle.image = UIImage(named: "canadianPuck")
        }
    }
    
    @IBAction func choix4Action(_ sender: UIButton) {
        if score >= 100 {
            balle.image = UIImage(named: "torontomaplePuck")
        }
    }
    
    //===========================================================
    //===========================================================
    
    //------------------RESET DES ITEMS--------------------------
    
    func resetDesItems(){
        locketat1.image = UIImage(named: "lock")
        locketat2.image = UIImage(named: "lock")
        locketat3.image = UIImage(named: "lock")
        locketat4.image = UIImage(named: "lock")
        
        balleDeFeu.alpha = 0.5
        oilers.alpha = 0.5
        canadien.alpha = 0.5
        toronto.alpha = 0.5
        
    }
    enum UIViewAnimationCurve : Int {
        case EaseInOut
        case EaseIn
        case EaseOut
        case Linear
    }
    
    
    
    
}

