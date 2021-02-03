//
//  ViewController.swift
//  FlipFlip
//
//  Created by Ta Huy Hung on 2/3/20.
//  Copyright © 2020 Class iOS. All rights reserved.
//

//to-do list
//1. cho cái animation chạy song song với tgian lúc preparing
//2. ko cho kêu ngửa màn hình khi chưa học => DONE
//3. xử lý tọa độ sao cho hơi ngửa lên vẫn phải kêu báo động -> k cho ng dùng lén xem => DONE


import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var circleTimerView : CircleView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var endStudyBtn: UIButton!
    
    var appIsRunning = false
    var timeOfTwoState: Int?
    var timeLearning = 30
    var timePreparing = 3
    var currentTime = 0
    var timer : MyTimer? = nil
    var audioPlayerForEndLearning : AVAudioPlayer?
    var audioPlayerHandleUserUsingPhone : AVAudioPlayer?
    let motionManager = CMMotionManager()
    var accelerationData : Double?
    
    
    var STATE : Int = 0
    var PREPARING : Int = 0
    var LEARNING : Int = 1
    var PHONEUP : Bool = true
    
    
    @IBAction func endStudyButtonTapped(_ sender: UIButton) {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        audioPlayerHandleUserUsingPhone?.stop()
        audioPlayerForEndLearning?.stop()
    }
    
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if appIsRunning {
            return
        }
        handle()
    }
    
    
    func handle() {
        appIsRunning = true
        currentTime = timePreparing
        handleState()
    }
    
    
    @objc func handleState() {
        timer?.invalidate()
        if(STATE == PREPARING){
            if(currentTime <= 0){
                STATE = LEARNING
                currentTime = timeLearning
            }
            else{
                prepareToCountDown()
            }
        }
        if(STATE == LEARNING){
            endStudyBtn.isHidden = false
            if(currentTime <= 0){
                print("time learing is end!")
                alert()
            }
            else{
                prepareToCountDown()
            }
        }
    }
    
    func prepareToCountDown(){
        timer = MyTimer.scheduledTimer(interval: 1.0, target: self, selector: #selector(countDown), repeate: true)
        circleTimerView.startAnimationCountdown(seconds: currentTime)
        
    }
    
    
    @objc func countDown(){
        currentTime -= 1
        timerLabel.text = timeString(time: TimeInterval(currentTime))
        print("currentTime: \(currentTime)")
        if STATE == LEARNING {
            handleUserUsingPhone()
        }
        if(currentTime <= 0){
            handleState()
        }
    }
    
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    
    func getURLAudioFile(_ nameAudio : String,_ fileType : String) -> URL{
        guard let fileURL = Bundle.main.path(forResource: nameAudio, ofType: fileType) else { return URL(fileURLWithPath: " ")}
        let url = URL(fileURLWithPath: fileURL)
        return url
    }
    
    
    func alert(){
        audioPlayerForEndLearning = try? AVAudioPlayer(contentsOf: getURLAudioFile("alarm", "mp3"))
        audioPlayerForEndLearning?.numberOfLoops = 1
        audioPlayerForEndLearning?.play()
    }
    
    
    func stopUserFromUsingPhone(){
        audioPlayerHandleUserUsingPhone = try? AVAudioPlayer(contentsOf: getURLAudioFile("AlarmPhoneUp", "mp3"))
        audioPlayerHandleUserUsingPhone?.numberOfLoops = 1
        audioPlayerHandleUserUsingPhone?.play()
    }
    
    
    func continueLearning(){
        audioPlayerHandleUserUsingPhone?.stop()
    }
    
    
    func handleUserUsingPhone(){
        if isUserCanUsePhone() {
            stopUserFromUsingPhone()
        }
        else{
            continueLearning()
        }
    }
    
    func isUserCanUsePhone() -> Bool{
        if isTestingOnSimulator(accelerationData) {
            return false
        }
        
        if accelerationData! < 0.8 {
            return true
        }
        else{
            return false
        }
    }
    
    func isTestingOnSimulator(_ accelerationData : Double?) -> Bool{
        if accelerationData == nil {
            return true
        }
        else{
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endStudyBtn.isHidden = true
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
            self.accelerationData = data?.acceleration.z
            print("Acceleration Z : \(data?.acceleration.z as Any) \n")
        }
    }
    
    
}





