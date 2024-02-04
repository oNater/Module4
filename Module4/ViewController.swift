//
//  ViewController.swift
//  Module4
//
//  Created by user250623 on 2/3/24.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var countdownTimer: Timer?
    var liveClockTimer: Timer?
    var remainingSeconds: Int = 0
    var player: AVAudioPlayer?
    var backgroundTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLiveClock()
        setupBackgroundTimer()
    }
    
    func setupLiveClock() {
        liveClockTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
        RunLoop.current.add(liveClockTimer!, forMode: .common)
        updateClock()
    }
    
    func setupBackgroundTimer() {
        backgroundTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateBackgroundImage()
        }
    }
    
    @objc func updateClock() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        label1.text = dateFormatter.string(from: Date())
        updateBackgroundImage()
    }
    
    func updateBackgroundImage() {
        let hour = Calendar.current.component(.hour, from: Date())
        let imageName = hour < 12 ? "dayImage" : "nightImage"
        backgroundImageView.image = UIImage(named: imageName)
    }
    
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if actionButton.titleLabel?.text == "Stop Music" {
            stopMusicAndReset()
        } else {
            startCountdown()
        }
    }
    
    func startCountdown() {
        remainingSeconds = Int(datePicker.countDownDuration)
        updateCountdownLabel()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
        
        actionButton.setTitle("Stop Music", for: .normal)
        datePicker.isEnabled = false
    }
    
    func updateCountdown() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            updateCountdownLabel()
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            playMusic()
        }
    }
    
    func updateCountdownLabel() {
        let hours = remainingSeconds / 3600
        let minutes = (remainingSeconds % 3600) / 60
        let seconds = (remainingSeconds % 3600) % 60
        label2.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "Music", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopMusicAndReset() {
        player?.stop()
        player = nil
        countdownTimer?.invalidate()
        countdownTimer = nil
        remainingSeconds = Int(datePicker.countDownDuration)
        updateCountdownLabel()
        actionButton.setTitle("Start Timer", for: .normal)
        label2.text = ""
        datePicker.isEnabled = true
        
    }
}
