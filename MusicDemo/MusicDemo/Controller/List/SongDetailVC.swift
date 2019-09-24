//
//  SongDetailVC.swift
//  MusicDemo
//
//  Created by  on 23/09/19.
//

import UIKit
import AVFoundation
import AVKit
import SVProgressHUD

class SongDetailVC: UIViewController {

    //MARK:- IBOutlet Declaration
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgAlbum:UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var lblStartTime: UILabel!
    
    @IBOutlet weak var lblEndTime: UILabel!
    
    @IBOutlet weak var btnPause: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnPrevious: UIButton!
    
    
    //MARK:- Variable Declaration
    
    var AudioURL:[SongsArray] = []
    
    var isSeekInProgress = false
    var player:AVPlayer?
    var chaseTime = CMTime.zero
    var playerCurrentItemStatus:AVPlayerItem.Status = .unknown
    
    var audioPlayer = AVAudioPlayer()
    var oldCurVal = 0
    var currntTime = 1
    var totalTime = 0
    var sliderVal = 0
    
    
    typealias CompletionHandler = (_ success:Bool , _ time:Int) -> Void
    
    var timer = Timer()
    
    
    let session = AVAudioSession.sharedInstance()
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.currentIndex = self.AudioURL.count > 0 ? 0 : self.currentIndex
        btnPrevious.isEnabled = self.currentIndex <= 1 ? false : true
        playURL(self.AudioURL[self.currentIndex].songUrl!)
         setupUI()
    }
    
    func setupUI(){
        let objData = AudioURL[currentIndex]
        self.imgAlbum.image = UIImage(named: (objData.albbumImage)!)
        self.lblTitle.text = objData.name
        
    }
    

    //MARK:- Back Button Code Here
    @IBAction func btnBackTapped(_ sender:UIButton){
        player?.pause()
        _ = self.navigationController?.popViewController(animated: true)
    }

}
extension SongDetailVC{
    // play Song from URL
    func playURL(_ playURL:String ){
        SVProgressHUD.show()
        currntTime = 0
        lblEndTime.text = "00:00"
        lblStartTime.text = "00:00"
        timer.invalidate()
        calculateTimeDurationOFSong(playURL) { (sucess, time) in
            DispatchQueue.main.async {
                if sucess == true{
                    self.lblEndTime.text = self.getTime(time)
                    
                    self.loadRadio(radioURL: playURL, time: time)
                    self.totalTime = time
                    
                }
                
            }
        }
    }
    
    @objc func PlayNow() {
        //example functionality
        timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter(_ time:Int) {
        //example functionality
        SVProgressHUD.dismiss()
        if currntTime < totalTime{
            currntTime = currntTime + 1
            lblStartTime.text = self.getTime(currntTime)
            self.progressBar.progress = Float(currntTime)/Float(totalTime)
        }
    }
    func calculateTimeDurationOFSong(_ audioURL:String , completionHandler: @escaping CompletionHandler){
        if let url = URL(string: audioURL){
            let audioAsset = AVURLAsset.init(url: url, options: nil)
            audioAsset.loadValuesAsynchronously(forKeys: ["duration"]) {
                var error: NSError? = nil
                let status = audioAsset.statusOfValue(forKey: "duration", error: &error)
                switch status {
                case .loaded: // Sucessfully loaded. Continue processing.
                    let duration = audioAsset.duration
                    let durationInSeconds = CMTimeGetSeconds(duration)
                    
                    completionHandler(true,Int(durationInSeconds))
                    break
                case .failed:
                    completionHandler(false,0)
                break // Handle error
                case .cancelled:
                    completionHandler(false,0)
                break// Terminate processing
                default:
                    completionHandler(false,0)
                    break // Handle all other cases
                }
            }
        }
    }
    
    func getTime(_ second:Int) -> String{
        let hours = second / 3600
        let minutes = (second / 60) % 60
        let seconds = second % 60
        if hours > 0{
            return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        }else {
            return String(format: "%0.2d:%0.2d", minutes, seconds)
        }
        
    }
    
    func loadRadio(radioURL: String , time:Int) {
        do {
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: .default,
                                    policy: .longForm,
                                    options: [])
        } catch let error {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }
        
        
        guard let url = URL.init(string: radioURL) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        player?.automaticallyWaitsToMinimizeStalling = false
        player?.play()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.PlayNow), userInfo: nil, repeats: false)
        self.progressBar.progress = 0
        
        
    }
    
    
    @IBAction func btnPreviousTapped(_ sender: UIButton) {
        player?.pause()
        progressBar.progress = 0
        self.currentIndex = self.currentIndex > 0 ? self.currentIndex - 1 : 0
        playURL(self.AudioURL[self.currentIndex].songUrl!)
        btnPrevious.isEnabled = self.currentIndex <= 1 ? false : true
        self.setupUI()
        btnNext.isEnabled = true
    }
    
    @IBAction func btnPausePlayTapped(_ sender: UIButton) {
        if btnPause.currentImage == UIImage(named: "pause.png") {
            player?.pause()
            //audioPlayer.pause()
            timer.invalidate()
            btnPause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }else{
            player?.play()
            //audioPlayer.play()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
            btnPause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        self.setupUI()
    }
    
    @IBAction func btnNextPlayTapped(_ sender: UIButton) {
        player?.pause()
        progressBar.progress = 0
        self.currentIndex = self.currentIndex + 1 >= self.AudioURL.count ? 0 : self.currentIndex + 1
        btnNext.isEnabled = self.currentIndex + 1 >= self.AudioURL.count ? false : true
        btnPrevious.isEnabled = self.currentIndex < 1 ? false : true
        self.setupUI()
        playURL(self.AudioURL[self.currentIndex].songUrl!)
        
    }
}
