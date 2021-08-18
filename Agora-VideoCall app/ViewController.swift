//
//  ViewController.swift
//  Agora-VideoCall app
//
//  Created by Shankar K on 16/08/21.
//

import UIKit
import AgoraRtcKit

//One to one Video Call Controller

class ViewController: UIViewController {
    
    var randomUserId: Int = 0
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var speakerContainer: UIView!
    @IBOutlet weak var recieverContainer: UIView!
    @IBOutlet weak var recieverVideoMutedIndicator: UIImageView!
    @IBOutlet weak var speakerVideoMutedIndicator: UIImageView!
    
    var speakerVideo: AgoraRtcVideoCanvas?
    var recieverVideo: AgoraRtcVideoCanvas?

    
    var isRecieverVideoRender: Bool = true {
        didSet {
            if let it = speakerVideo, let view = it.view {
                if view.superview == speakerContainer {
                    recieverVideoMutedIndicator.isHidden = isRecieverVideoRender
//                    recieverContainer.isHidden = !isRecieverVideoRender
                    self.recieverContainer.bringSubviewToFront(recieverVideoMutedIndicator)

                } else if view.superview == recieverContainer {
                    speakerVideoMutedIndicator.isHidden = isRecieverVideoRender
                    self.speakerContainer.bringSubviewToFront(speakerVideoMutedIndicator)

                }
            }
        }
    }
    
    var isSpeakerVideoRender: Bool = false {
        didSet {
            if let it = speakerVideo, let view = it.view {
                if view.superview == speakerContainer {
                    speakerVideoMutedIndicator.isHidden = isSpeakerVideoRender
                    self.speakerContainer.bringSubviewToFront(speakerVideoMutedIndicator)
                } else if view.superview == recieverContainer {
                    recieverVideoMutedIndicator.isHidden = isSpeakerVideoRender
                    self.recieverContainer.bringSubviewToFront(recieverVideoMutedIndicator)
                }
            }
        }
    }
    
    var isStartCalling: Bool = true {
        didSet {
            if isStartCalling {
                micButton.isSelected = false
            }
            micButton.isHidden = !isStartCalling
            cameraButton.isHidden = !isStartCalling
        }
    }

    // Defines agoraKit
    var agoraKit: AgoraRtcEngineKit?

    override func viewDidLoad() {
    super.viewDidLoad()
        randomUserId = Int.random(in: 0..<100)
        initializeAgoraEngine()
        setupVideo()
        setupLocalVideo()
        joinChannel()
        self.speakerContainer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handler)))

    }
    
    func setupVideo() {
        agoraKit?.enableVideo()
        
        agoraKit?.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
             frameRate: .fps10,
             bitrate: AgoraVideoBitrateStandard,
             orientationMode: .adaptative))
    }

    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self)
    }
    
    //UIPanGestureRecognizer handler
    @objc func handler(gesture: UIPanGestureRecognizer){
        let location = gesture.location(in: self.view)
        let draggedView = gesture.view
        draggedView?.center = location

        if gesture.state == .ended {
            if self.speakerContainer.frame.midX >= self.view.layer.frame.width / 2 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.speakerContainer.center.x = self.view.layer.frame.width - 60
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.speakerContainer.center.x = 60
                }, completion: nil)
            }
        }
    }

    // Sets the video view layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    
    func setupLocalVideo() {
        // Enables the video module
        agoraKit?.enableVideo()
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: speakerContainer.frame.size))
        speakerVideo = AgoraRtcVideoCanvas()
        speakerVideo!.view = view
        speakerVideo!.renderMode = .hidden
        speakerVideo!.uid = UInt(randomUserId)
        speakerContainer.addSubview(speakerVideo!.view!)
        agoraKit?.setupLocalVideo(speakerVideo)
        agoraKit?.startPreview()
    }
    
    func joinChannel(){
        // The uid of each user in the channel must be unique.
        agoraKit?.joinChannel(byToken: Token, channelId: "1", info: nil, uid: UInt(randomUserId), joinSuccess: { (channel, uid, elapsed) in
            
        })
    }
    func leaveChannel() {
        agoraKit?.leaveChannel(nil)
    }
    
    @IBAction func switchCameraAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        agoraKit?.switchCamera()
    }
    
    
    @IBAction func callHandlerAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            leaveChannel()
            AgoraRtcEngineKit.destroy()
            navigationController?.popViewController(animated: true)
        } else {
            setupLocalVideo()
            joinChannel()
        }
    }
    
    @IBAction func mikeHandlerAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        // mute local audio
        isSpeakerVideoRender = !sender.isSelected
        agoraKit?.muteLocalAudioStream(sender.isSelected)
        self.view.makeToast(isSpeakerVideoRender == true ? "unmutted" : "mutted", duration: 2.0, position: .bottom)
    }
    
    @IBAction func videoTurnOnOff(_ sender: UIButton) {
        sender.isSelected.toggle()
        // mute local audio
        if(sender.isSelected){
            agoraKit?.disableVideo()
        }else{
            agoraKit?.enableVideo()
        }
    }
    
    @IBAction func didClickLocalVideo(_ sender: Any) {
        switchContainer(speakerVideo)
        switchContainer(recieverVideo)
    }
    
    func switchContainer(_ canvas: AgoraRtcVideoCanvas?) {
        let parent = removeFromParent(canvas)
        if parent == speakerContainer {
            canvas!.view!.frame.size = recieverContainer.frame.size
            canvas!.view?.cornerRadius = 15
            recieverContainer.addSubview(canvas!.view!)
        } else if parent == recieverContainer {
            canvas!.view!.frame.size = speakerContainer.frame.size
            canvas!.view?.cornerRadius = 15
            speakerContainer.addSubview(canvas!.view!)
        }
    }
    
    func removeFromParent(_ canvas: AgoraRtcVideoCanvas?) -> UIView? {
        if let it = canvas, let view = it.view {
            let parent = view.superview
            if parent != nil {
                view.removeFromSuperview()
                return parent
            }
        }
        return nil
    }
    
    
}


extension ViewController: AgoraRtcEngineDelegate {
    // Monitors the didJoinedOfUid callback
    // The SDK triggers the callback when a remote user joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        var parent: UIView = recieverContainer
        if let it = speakerVideo, let view = it.view {
            if view.superview == parent {
                parent = speakerContainer
            }
        }

        if recieverVideo != nil {
            return
        }

        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: parent.frame.size))
        recieverVideo = AgoraRtcVideoCanvas()
        recieverVideo!.view = view
        recieverVideo!.renderMode = .hidden
        recieverVideo!.uid = uid
        parent.addSubview(recieverVideo!.view!)
        agoraKit?.setupRemoteVideo(recieverVideo!)

    }
    
    //local Video did stopped
    func rtcEngineVideoDidStop(_ engine: AgoraRtcEngineKit) {
        debugPrint("rtcEngineVideoDidStop : Video not available")
        self.view.makeToast("Video stopped", duration: 3, position: .bottom)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoEnabled enabled: Bool, byUid uid: UInt) {
        if(!enabled) {
            self.view.makeToast("Speaker Video paused", duration: 3, position: .bottom)
        }

    }
    
    //User Connection Lost
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        debugPrint("rtcEngineConnectionDidLost : Connection not available")
        self.view.makeToast("Connection Lost, check your connection", duration: 3, position: .bottom)
    }
    
    //User Camera is ready
    func rtcEngineCameraDidReady(_ engine: AgoraRtcEngineKit) {
        debugPrint("rtcEngineCameraDidReady : Camera is Ready ")
    }
    
    //Speaker mutted or not
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        isRecieverVideoRender = !muted
        debugPrint("didAudioMuted : Audio mutted ",muted)
        self.view.makeToast(muted == true ? "speaker mutted" : "speaker unmutted", duration: 2.0, position: .bottom)

    }
    
    //User didMicrophoneEnabled
    func rtcEngine(_ engine: AgoraRtcEngineKit, didMicrophoneEnabled enabled: Bool) {
        debugPrint("rtcEngineMediaEngineDidStartCall : didMicrophoneEnabled ",enabled)
    }
    
    //User Started Call
    func rtcEngineMediaEngineDidStartCall(_ engine: AgoraRtcEngineKit) {
        debugPrint("rtcEngineMediaEngineDidStartCall : Call Started ")
    }
    
    //User connection Interrupted
    func rtcEngineConnectionDidInterrupted(_ engine: AgoraRtcEngineKit) {
        debugPrint("rtcEngineConnectionDidInterrupted : Connect Interrupted ")
        self.view.makeToast("Connect Interrupted", duration: 3, position: .bottom)
    }
    
    func rtcEngineConnectionDidBanned(_ engine: AgoraRtcEngineKit) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        isRecieverVideoRender = !muted
        debugPrint("didVideoMuted : Video mutted ",muted)
        self.view.makeToast(muted == true ? "speaker mutted" : "speaker unmutted", duration: 2.0, position: .bottom)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        isRecieverVideoRender = false
        if let it = recieverVideo, it.uid == uid {
            removeFromParent(it)
            recieverVideo = nil
        }
    }
    
}
