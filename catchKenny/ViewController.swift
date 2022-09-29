//
//  ViewController.swift
//  catchKenny
//
//  Created by Ios Developer on 29.09.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var kenny1: UIImageView!
    @IBOutlet weak var kenny2: UIImageView!
    @IBOutlet weak var kenny3: UIImageView!
    @IBOutlet weak var kenny4: UIImageView!
    @IBOutlet weak var kenny5: UIImageView!
    @IBOutlet weak var kenny6: UIImageView!
    @IBOutlet weak var kenny7: UIImageView!
    @IBOutlet weak var kenny8: UIImageView!
    @IBOutlet weak var kenny9: UIImageView!
    
    var score = 0
    var timer = Timer()
    var counter = 0
    var kennyArray = [UIImageView]()
    var hideTimer = Timer() // otomatik gizleme için zamanlayıcının içine koymalıyız
    var highScore = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //high score kontrolü
        let storedHighScore = UserDefaults.standard.object(forKey: "high")
        if storedHighScore == nil {
            highScore = 0
            highScoreLabel.text = "highScore: \(highScore)"
        }
        if let newScore = storedHighScore as? Int{
            highScore = newScore
            highScoreLabel.text = "highScore: \(highScore)"
            
        }
        
        
        // images  1. adım
        scoreLabel.text = "Score: \(score)"
        
        kenny1.isUserInteractionEnabled = true
        kenny2.isUserInteractionEnabled = true
        kenny3.isUserInteractionEnabled = true
        kenny4.isUserInteractionEnabled = true
        kenny5.isUserInteractionEnabled = true
        kenny6.isUserInteractionEnabled = true
        kenny7.isUserInteractionEnabled = true
        kenny8.isUserInteractionEnabled = true
        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(PlusFunc))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(PlusFunc))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(PlusFunc))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(PlusFunc))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(PlusFunc))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(PlusFunc))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(PlusFunc))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(PlusFunc))
        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(PlusFunc))
        
        kenny1.addGestureRecognizer(recognizer1)
        kenny2.addGestureRecognizer(recognizer2)
        kenny3.addGestureRecognizer(recognizer3)
        kenny4.addGestureRecognizer(recognizer4)
        kenny5.addGestureRecognizer(recognizer5)
        kenny6.addGestureRecognizer(recognizer6)
        kenny7.addGestureRecognizer(recognizer7)
        kenny8.addGestureRecognizer(recognizer8)
        kenny9.addGestureRecognizer(recognizer9)
        
        
        kennyArray = [kenny1,kenny2,kenny3,kenny4,kenny5,kenny6,kenny7,kenny8,kenny9]
        
        //timer  2.adım
        counter = 10
        TimeLabel.text = String(counter)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDown), userInfo: nil, repeats: true)
        
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideKenny), userInfo: nil, repeats: true) // hidetimeri 0da sonlandırmak için aşağı in if counter == 0 oldugunda durdur de yani hidetimer.invalidate() yap.
        
        hideKenny() // func hideKenny() in bi yerde çalışması için çagırmamız gerekiyor burda
        
        
    }
    @objc func hideKenny(){   // başına objc yi hideTimeri oluşturmak için sonradan koyduk.
        for kenny in kennyArray{
            kenny.isHidden = true
        }
        let random = Int(arc4random_uniform(UInt32(kennyArray.count-1))) // random sayı böyle çağrılır kennyArray.count 9tane kenny oldugu için 9 sayar ama diziler 0 dan başlar yani 8 son sayımız o yğzden eksi bir deriz. arc4random_uniform(UInt32(kennyArray.count-1)) VE BU INT DÖNMEZ INT E ÇEVİR let random = ınt () dedik
       
        kennyArray[random].isHidden = false // kennyleri random açıcak is hidden false oldugu için görünmezi görünür kılar.
        
        
        
    }
    @objc func PlusFunc(){
        score += 1
        scoreLabel.text = "score: \(score)"
        
        
    }
    @objc func timerDown(){
        counter -= 1
        TimeLabel.text = String(counter)
        
        if counter == 0 {
            timer.invalidate()
            hideTimer.invalidate()
            
            for kenny in kennyArray{
                kenny.isHidden = true
            }  // bunu ve hide timeri sonradan ekledik buraya . Bu for döngüsünü bir daha buraya koyma sebebimiz zaman bitince tüm kennyleri tekrar görünmez hale getirmek.
            
            
            // hıgh SCORE SCOREEEEEE
            if self.score > self.highScore {
                self.highScore = self.score
                self.highScoreLabel.text = "highScore: \(self.highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "high")
            }
            
            
            
            let alert = UIAlertController(title: "time is up", message: "Do you want to play again ?", preferredStyle: UIAlertController.Style.alert)
            let okButton =  UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { UIAlertAction in
                self.score = 0   // her seyşn basına self koy anlamıyor wievden cektigimizi.
                self.scoreLabel.text = "Score \(self.score)"
                self.counter = 10
                self.TimeLabel.text = String (self.counter)
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerDown), userInfo: nil, repeats: true)
                
                self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hideKenny), userInfo: nil, repeats: true)
                // zamanlayıcılar da sıfırlansın
                
            }
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true)
        }
    }

}

