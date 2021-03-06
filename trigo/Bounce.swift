//--------------------------------------------------
//--------------------------------------------------
import UIKit
import Foundation
//--------------------------------------------------
//--------------------------------------------------
class Bounce {
    //--------------------------------------------------
    var b: UIImageView!
    var lw: UIView!
    var rw: UIView!
    var tw: UIView!
    var bw: UIView!
    var def3 : UIView!
    var def : UIView!
    var PoteauGauche : UIView!
    var PoteauDroit: UIView!
    //--------------------------------------------------
    init(ball b: UIImageView!,
         left_window lw: UIView,
         right_window rw: UIView,
         top_window tw: UIView,
         bottom_window bw: UIView,
         defenseur3 def3 : UIView,
         defenseur def : UIView,
         PoteauGauche: UIView,
         PoteauDroit: UIView) {
        self.b = b
        self.lw = lw
        self.rw = rw
        self.tw = tw
        self.bw = bw
        self.def3 = def3
        self.def = def
        self.PoteauGauche = PoteauGauche
        self.PoteauDroit = PoteauDroit
    }
    //--------------------------------------------------
    func returnCosSinAfterTouch(sin s: Double, cos c: Double) -> [Double] {
        let r = atan2f(Float(s), Float(c))
        var d = r * (180 / Float(Double.pi))
        if b.frame.intersects(lw.frame) || b.frame.intersects(rw.frame) {
            d = 180 - d }
        if b.frame.intersects(tw.frame) {
            let p = abs(d)
            d=p }
        if b.frame.intersects(bw.frame) {
            let n = (d) * -1
            d=n }
        if b.frame.intersects(def3.frame) {
            let i = abs(d)
            d = i }
        if b.frame.intersects(def.frame) {
            let u = abs(d)
            d = u }
        
        //---POTEAU--------
        if b.frame.intersects(PoteauGauche.frame) {
            let p1 = abs(d)
            d = p1 }
        
        if b.frame.intersects(PoteauDroit.frame) {
            let p2 = abs(d)
            d = p2 }
        
        
        
        
        return [__sinpi(Double(d/180.0)), __cospi(Double(d/180.0))]
    }
    //--------------------------------------------------
}
//--------------------------------------------------
//--------------------------------------------------

