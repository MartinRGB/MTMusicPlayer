//
//  ViewController.swift
//
//  Created by MartinRGB on 15/12/02.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit
import AVFoundation

//MARK:DATA

struct AlbumModel {
    let title:String
    let image:UIImage!
    let songurl:NSURL!
    
}

let albumData = [
    AlbumModel(title:"LEFT TO OUR OWN DEVICES",image:UIImage(named:"album1"),songurl:NSBundle.mainBundle().URLForResource("song6", withExtension: "mp3")!),
    AlbumModel(title:"ANDREW MCMAHON IN THE WILDERNESS",image:UIImage(named:"album2"),songurl:NSBundle.mainBundle().URLForResource("song7", withExtension: "mp3")!),
    AlbumModel(title:"CONTRAST",image:UIImage(named:"album3"),songurl:NSBundle.mainBundle().URLForResource("song6", withExtension: "mp3")!),
    AlbumModel(title:"GLASS BOYS",image:UIImage(named:"album4"),songurl:NSBundle.mainBundle().URLForResource("song7", withExtension: "mp3")!),
    AlbumModel(title:"HOW TO RUN AWAY",image:UIImage(named:"album5"),songurl:NSBundle.mainBundle().URLForResource("song6", withExtension: "mp3")!),
    AlbumModel(title:"LA BRONZE",image:UIImage(named:"album6"),songurl:NSBundle.mainBundle().URLForResource("song7", withExtension: "mp3")!),
    AlbumModel(title:"PEOPLE UNDER THE STAIRS",image:UIImage(named:"album7"),songurl:NSBundle.mainBundle().URLForResource("song6", withExtension: "mp3")!),
    AlbumModel(title:"POEMSS",image:UIImage(named:"album8"),songurl:NSBundle.mainBundle().URLForResource("song7", withExtension: "mp3")!),
    AlbumModel(title:"SWIM TEAM",image:UIImage(named:"album9"),songurl:NSBundle.mainBundle().URLForResource("song6", withExtension: "mp3")!),
    AlbumModel(title:"THE PAINS OF BEING PURE AT HEART",image:UIImage(named:"album10"),songurl:NSBundle.mainBundle().URLForResource("song7", withExtension: "mp3")!)
]

//MARK:Controller
class ViewController: UICollectionViewController {
    
    private var scrollIndex:Int = 0
    private let atitleView:UIView = UIView()
    private let atitleLabel:UILabel = UILabel()
    private let atitleLabel2:UILabel = UILabel()
    private let CellIdentifier = "CollectionCell"
    private let AVView:UIView = UIView()
    private var player:AVPlayer! = AVPlayer()
    private var playerLayer:AVPlayerLayer! = AVPlayerLayer()
    private var playerImageView:UIImageView! = UIImageView()
    private var vinylView:UIView! = UIView()
    private var vinylView2:UIView! = UIView()
    private var vinylImageView:UIImageView! = UIImageView()
    private var vinylImageView2:UIImageView! = UIImageView()
    private var scrollViewBeforeScroll:CGFloat = 0
    
    private var timeMaker1:UILabel! = UILabel()
    
    private var playPauseImageView:UIImageView! = UIImageView()
    private let tapRec:UITapGestureRecognizer = UITapGestureRecognizer()
    
    private var secondObserver: AnyObject!
    private var durationObserver:AnyObject!
    private var sliderObserver:AnyObject!
    
    private var secondMinute:String! = "00"
    private var secondSecond:String! = "00"
    private var totalMinute:String! = "03"
    private var totalSecond:String! = "11"
    private var totalValue:Double = 191.0
    private var secondValue:Double! = 0.0
    
    private let customSlider:UISlider! = UISlider()
    private var sliderNowValue:Float = 0.0
    private var sliderIsDragging = false;
    
//MARK:ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImageView = UIImageView(frame: CGRectMake(0,0,self.view.bounds.width,self.view.bounds.height))
        self.view.insertSubview(bgImageView, belowSubview: collectionView!)
        bgImageView.image = UIImage(named: "tvBG")
        self.collectionView!.backgroundColor =  UIColor.clearColor()
        
        addTitleLabel()
        addAlbumTitleLabel()
        addAV()
        addVinyl()
        updateTimetoTimeMarker()
    }
    
//MARK:初始化与布局调整
    
    //MARK:Landscape
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft,UIInterfaceOrientationMask.LandscapeRight]
    }
    
    //MARK:Top Title
    private func addTitleLabel() {
        let titleLabel = UILabel(frame: CGRectMake(self.view.bounds.width/2-widthfortitle().width/2,self.view.bounds.height * 0.111,widthfortitle().width,widthfortitle().height))
        titleLabel.text = "MY MUSIC"
        titleLabel.font = UIFont(name: "DIN-Bold", size: 24)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.alpha = 0.5
        self.view.addSubview(titleLabel)
    }
    
    private func widthfortitle() -> CGSize {
        let titleString = NSMutableAttributedString(
            string:"My MUSIC",
            attributes: [NSFontAttributeName:UIFont(
                name: "DIN-Bold",
                size: 26)!])
        
        return titleString.size()
        
    }
    
    //MARK:Title Label:Add the title Label & 滑动效果的开始效果
    func addAlbumTitleLabel(){
        self.view.addSubview(atitleView)
        atitleView.backgroundColor = UIColor(red: 252/255, green: 212/255, blue: 24/255, alpha: 1.0)
        atitleView.frame = CGRectMake(self.view.bounds.width/2 - (self.sizeForLabel(self.scrollIndex).width + 40)/2,self.view.bounds.height * 0.592,self.sizeForLabel(self.scrollIndex).width + 40,self.view.bounds.size.width * 0.293/5)
        
        atitleLabel.frame = CGRectMake(self.atitleView.frame.size.width/2 - self.sizeForLabel(self.scrollIndex).width/2,self.atitleView.frame.size.height/2 - self.sizeForLabel(self.scrollIndex).height/2,self.sizeForLabel(self.scrollIndex).width,self.sizeForLabel(self.scrollIndex).height)
        
        atitleLabel.text = albumData[self.scrollIndex].title
        atitleLabel.font = UIFont(name: "DIN-Bold", size: 24)
        atitleLabel.textColor = UIColor.blackColor()
        atitleLabel.textAlignment = NSTextAlignment.Center
        
        atitleLabel2.frame = CGRectMake((self.atitleView.frame.size.width/2 - self.sizeForLabel(self.scrollIndex+1).width/2) + self.view.bounds.width/3 ,(self.atitleView.frame.size.height/2 - self.sizeForLabel(self.scrollIndex+1).height/2) - self.view.bounds.height/3,self.sizeForLabel(self.scrollIndex+1).width,self.sizeForLabel(self.scrollIndex+1).height)
        
        atitleLabel2.text = albumData[self.scrollIndex+1].title
        atitleLabel2.font = UIFont(name: "DIN-Bold", size: 24)
        atitleLabel2.textColor = UIColor.blackColor()
        atitleLabel2.textAlignment = NSTextAlignment.Center
        
        atitleView.addSubview(atitleLabel)
        atitleView.addSubview(atitleLabel2)
        atitleView.clipsToBounds = true
    }
    
    //MARK:Title Label:Calcuate the size of text
    func sizeForLabel(indexNumber:Int) -> CGSize
    {
        let labelString = NSMutableAttributedString(
            string: albumData[indexNumber].title,
            attributes: [NSFontAttributeName:UIFont(
                name: "DIN-Bold",
                size: 24)!])
        
        return labelString.size()
    }
    
    //MARK:Vinyl
    func addVinyl(){
        //add the vinyl
        vinylImageView.image = UIImage(named: "Vinyl")
        vinylImageView2.image = UIImage(named: "Vinyl")
        vinylView.addSubview(vinylImageView)
        vinylView2.addSubview(vinylImageView2)
        
        
        self.view.insertSubview(vinylView, belowSubview: collectionView!)
        self.view.insertSubview(vinylView2, belowSubview: collectionView!)
        
        vinylView.frame = CGRectMake(collectionView!.bounds.size.width * 0.3935 + 60, collectionView!.bounds.size.width * (0.197), collectionView!.bounds.size.width*0.259 , collectionView!.bounds.size.width*0.259)
        vinylImageView.frame = CGRectMake(0, 0, vinylView.frame.size.width, vinylView.frame.size.height)
        vinylView.transform = CGAffineTransformMakeScale(1 , 1 )
        
        vinylView2.frame = CGRectMake(collectionView!.bounds.size.width * (0.7215) + 60 , collectionView!.bounds.size.width * (0.197), collectionView!.bounds.size.width*0.259 , collectionView!.bounds.size.width*0.259)
        vinylImageView2.frame = CGRectMake(0, 0, vinylView2.frame.size.width, vinylView2.frame.size.height)
        vinylView2.transform = CGAffineTransformMakeScale(0.6, 0.6)
        
    }
    
    //MARK:AVPlayer AVView
    func addAV(){
        
        //add AVView
        AVView.frame = CGRectMake(0, self.view.bounds.height * 0.852, self.view.bounds.width, self.view.bounds.height*0.148)
        AVView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(AVView)
        
        
        
        //add bottom Left Image
        playerImageView.frame = CGRectMake(0, self.view.bounds.height * 0.836, self.view.bounds.height * 0.164, self.view.bounds.height * 0.164)
        playerImageView.image = albumData[scrollIndex].image
        self.view.addSubview(playerImageView)
        
        let playerImageBackgroundView = UIView()
        playerImageBackgroundView.frame = CGRectMake(0, self.view.bounds.height * 0.836, self.view.bounds.height * 0.164, self.view.bounds.height * 0.164)
        playerImageBackgroundView.backgroundColor = UIColor.blackColor()
        playerImageBackgroundView.alpha = 0.7
        self.view.addSubview(playerImageBackgroundView)
        
        //Play & Pause Button
        let containerViewForPP = UIView()
        containerViewForPP.frame = CGRectMake(self.view.bounds.height * (0.164-0.049)/2,self.view.bounds.height * ((0.164-0.054)/2 + 0.838),self.view.bounds.height * 0.049,self.view.bounds.height * 0.054)
        
        self.view.addSubview(containerViewForPP)
        
        
        
        playPauseImageView.frame = CGRectMake(0,0,self.view.bounds.height * 0.049,self.view.bounds.height * 0.054)
        playPauseImageView.image = UIImage(named: "pause")
        
        
        containerViewForPP.addSubview(playPauseImageView)
        containerViewForPP.addGestureRecognizer(tapRec)
        tapRec.addTarget(self, action: Selector("tappedPP:"))
        
        //Add the timemarker Label
        timeMaker1.frame = CGRectMake(self.view.bounds.width * 0.834 , self.view.bounds.height * 0.9, self.view.bounds.height * 0.194, self.view.bounds.height * 0.056)
        self.timerWatch()
        
        
        timeMaker1.font = UIFont(name: "DIN-Bold", size: 24)
        timeMaker1.textColor = UIColor.blackColor()
        timeMaker1.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(timeMaker1)
        
        //Add Slider
        customSlider.frame = CGRectMake(self.view.bounds.height * 0.194, self.view.bounds.height * 0.888, self.view.bounds.height * 0.9, self.view.bounds.height * 0.083)
        customSlider.backgroundColor = UIColor.clearColor()
        customSlider.setMaximumTrackImage(UIImage(named: "min"), forState: .Normal)
        customSlider.setMinimumTrackImage(UIImage(named: "max"), forState: .Normal)
        
        
        customSlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        customSlider.addTarget(self, action: "sliderTouchDragEnter:", forControlEvents: .TouchDown)
        customSlider.addTarget(self, action: "sliderTouchDragExit:", forControlEvents: .TouchUpInside)
        customSlider.addTarget(self, action: "sliderTouchDragExit:", forControlEvents: .TouchUpOutside)
        customSlider.addTarget(self, action: "sliderTouchDragExit:", forControlEvents: .TouchCancel)
        
        self.view.addSubview(customSlider)
        
        
        //Add End Observer
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "playerItemDidReachEnd:",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object:nil)
        
        //Add AVPlayer
        do{
            playItemAtUrl(albumData[self.scrollIndex].songurl)
            player.pause()
            playPauseImageView.image = UIImage(named: "Play")
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch {
            print("Error getting the audio file")
        }
        
        
        
    }
    
    
    
    //MARK:AVPlayer AVPlayerLayer
    func playItemAtUrl(url: NSURL) {
        
        player = AVPlayer(URL: url)
        playerLayer = AVPlayerLayer(player: player)
        player.currentItem?.canPlayReverse
        player.currentItem?.canPlayFastReverse
        player.currentItem?.canPlayFastForward
        playerLayer.backgroundColor = UIColor.redColor().CGColor
        playerLayer.frame = AVView.frame
        AVView.layer.addSublayer(playerLayer)
        
    }
    
    //MARK:AVPlayer PlayReachEnd Notification
    func playerItemDidReachEnd(notif: NSNotification) {
        
        print("playerItemDidReachEnd")
        
    }
    
    //MARK:CollectionView DataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        cell.layer.allowsEdgeAntialiasing = true
        
        
        
        let cellImageView = UIImageView(frame: CGRectMake(0, 0, collectionView.bounds.size.width*0.293, collectionView.bounds.size.width*0.293))
        cellImageView.image = albumData[indexPath.item].image
        cell.contentView.addSubview(cellImageView)
        
        
        
        return cell
    }
    
    //MARK:CollectionView Delegate
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        scrollIndex = 0 + Int(collectionView!.contentOffset.x/self.view.bounds.width)
        
        self.playerImageView.image = albumData[self.scrollIndex].image
        
        //Player Control Part
        player.pause()
        playPauseImageView.image = UIImage(named: "pause")
        playItemAtUrl(albumData[self.scrollIndex].songurl)
        player.play()
        updateTimetoTimeMarker()
        
        //获得清零计数累加
        scrollViewBeforeScroll = (collectionView?.contentOffset.x)!
        //解决连续滑动bug
        scrollView.userInteractionEnabled = true
        
        sliderNowValue = 0
        
    }
    
    //MARK:CollectionView Delegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.view.insertSubview(vinylView, belowSubview: collectionView!)
        self.view.insertSubview(vinylView2, belowSubview: collectionView!)
        
        //到头后，去掉一张盘，防止露馅
        if scrollView.contentOffset.x >= 9216{
            vinylView.removeFromSuperview()
        }
        
        if scrollView.contentOffset.x <= 0{
            vinylView2.removeFromSuperview()
        }
        
        let scrollProgress = (scrollView.contentOffset.x - scrollViewBeforeScroll)/self.view.bounds.width
        
        //范围
        if(scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < 9216){
            //左滑
            if (scrollProgress > 0){
                //Vinyl Progress动画
                vinylView2.transform = CGAffineTransformMakeScale(0.6, 0.6)
                vinylView.transform = CGAffineTransformMakeScale(1, 1)
                
                vinylView.frame = CGRectMake(collectionView!.bounds.size.width * (0.3955 - (0.57 * scrollProgress)) + 60, collectionView!.bounds.size.width * 0.197 , collectionView!.bounds.size.width*0.259 , collectionView!.bounds.size.width*0.259)
                vinylImageView.frame = CGRectMake(0, 0, vinylView.frame.size.width, vinylView.frame.size.height)
                vinylView.transform = CGAffineTransformMakeScale(1 - 0.4 * scrollProgress, 1 - 0.4 * scrollProgress)
                
                vinylView2.frame = CGRectMake(collectionView!.bounds.size.width * (0.7715 - (0.290 * scrollProgress)) + 60, collectionView!.bounds.size.width * (0.25 + 0.035 * scrollProgress), collectionView!.bounds.size.width*0.259 , collectionView!.bounds.size.width*0.259)
                vinylImageView2.frame = CGRectMake(0, 0, vinylView2.frame.size.width, vinylView2.frame.size.height)
                vinylView2.transform = CGAffineTransformMakeScale(0.6 + 0.4 * scrollProgress, 0.6 + 0.4 * scrollProgress)
                
                //黄色LabelProgress动画
                let atitleVieworiginx = self.view.bounds.width/2 - (self.sizeForLabel(self.scrollIndex).width + 40)/2
                let atitleVieworiginw = self.sizeForLabel(self.scrollIndex).width + 40
                let atitleViewchangedx = (self.sizeForLabel(self.scrollIndex).width + 40)/2 - (self.sizeForLabel(self.scrollIndex + 1).width + 40)/2
                let atitleViewchangedw = self.sizeForLabel(self.scrollIndex).width - self.sizeForLabel(self.scrollIndex + 1).width
                
                self.atitleView.frame = CGRectMake(atitleVieworiginx + scrollProgress * atitleViewchangedx,self.view.bounds.height * 0.592,atitleVieworiginw - atitleViewchangedw * scrollProgress,self.view.bounds.size.width * 0.293/5)
                
                //文本LabelProgress动画
                atitleLabel.frame = CGRectMake((self.atitleView.frame.size.width/2 - self.sizeForLabel(self.scrollIndex).width/2) - self.view.bounds.width/3 * scrollProgress,(self.atitleView.frame.size.height/2 - self.sizeForLabel(self.scrollIndex).height/2) + self.view.bounds.height/3 * -scrollProgress ,self.sizeForLabel(self.scrollIndex).width,self.sizeForLabel(self.scrollIndex).height)
                atitleLabel.text = albumData[self.scrollIndex].title
                atitleLabel.alpha = 1 - 4 * scrollProgress
                
                atitleLabel2.frame = CGRectMake((self.atitleView.frame.size.width/2 - self.sizeForLabel(self.scrollIndex+1).width/2) + self.view.bounds.width/3 * (1-scrollProgress) ,(self.atitleView.frame.size.height/2 - self.sizeForLabel(self.scrollIndex+1).height/2) - self.view.bounds.height/3 * (1-scrollProgress),self.sizeForLabel(self.scrollIndex+1).width,self.sizeForLabel(self.scrollIndex+1).height)
                atitleLabel2.text = albumData[self.scrollIndex+1].title
                atitleLabel2.alpha = scrollProgress*10 - 9
                
                
                
                scrollView.userInteractionEnabled = false
            }
                //右滑
            else{
                //Vinyl Progress动画
                vinylView2.transform = CGAffineTransformMakeScale(0.6, 0.6)
                vinylView.transform = CGAffineTransformMakeScale(1, 1)
                
                vinylView.frame = CGRectMake(collectionView!.bounds.size.width * ( -0.1765 - (0.57 * scrollProgress)) + 60, collectionView!.bounds.size.width * 0.197, collectionView!.bounds.size.width*0.259 , collectionView!.bounds.size.width*0.259)
                vinylImageView.frame = CGRectMake(0, 0, vinylView.frame.size.width, vinylView.frame.size.height)
                vinylView.transform = CGAffineTransformMakeScale(0.6 - 0.4 * scrollProgress, 0.6 - 0.4 * scrollProgress)
                
                vinylView2.frame = CGRectMake(collectionView!.bounds.size.width * (0.4815 - (0.290 * scrollProgress)) + 60 , collectionView!.bounds.size.width * (0.285 + 0.035 * scrollProgress), collectionView!.bounds.size.width*0.259 , collectionView!.bounds.size.width*0.259)
                vinylImageView2.frame = CGRectMake(0, 0, vinylView2.frame.size.width, vinylView2.frame.size.height)
                vinylView2.transform = CGAffineTransformMakeScale(1 + 0.4 * scrollProgress, 1 + 0.4 * scrollProgress)
                
                //黄色LabelProgress动画
                
                
                let atitleVieworiginx = self.view.bounds.width/2 - (self.sizeForLabel(self.scrollIndex).width + 40)/2
                let atitleVieworiginw = self.sizeForLabel(self.scrollIndex).width + 40
                let atitleViewchangedx = (self.sizeForLabel(self.scrollIndex).width + 40)/2 - (self.sizeForLabel(self.scrollIndex - 1).width + 40)/2
                let atitleViewchangedw = self.sizeForLabel(self.scrollIndex).width - self.sizeForLabel(self.scrollIndex - 1).width
                
                self.atitleView.frame = CGRectMake(atitleVieworiginx - scrollProgress * atitleViewchangedx,self.view.bounds.height * 0.592,atitleVieworiginw + atitleViewchangedw * scrollProgress,self.view.bounds.size.width * 0.293/5)
                
                //文本LabelProgress动画
                atitleLabel.frame = CGRectMake((self.atitleView.frame.size.width/2 - self.sizeForLabel(self.scrollIndex - 1).width/2) + self.view.bounds.width/3 * (-1 - scrollProgress),(self.atitleView.frame.size.height/2 - self.sizeForLabel(self.scrollIndex - 1).height/2) + self.view.bounds.height/3 * (-1 - scrollProgress) ,self.sizeForLabel(self.scrollIndex - 1).width,self.sizeForLabel(self.scrollIndex - 1).height)
                atitleLabel.text = albumData[self.scrollIndex - 1].title
                atitleLabel.alpha = -scrollProgress*10 - 9
                
                atitleLabel2.frame = CGRectMake((self.atitleView.frame.size.width/2 - self.sizeForLabel(self.scrollIndex).width/2) - self.view.bounds.width/3 * (scrollProgress) ,(self.atitleView.frame.size.height/2 - self.sizeForLabel(self.scrollIndex).height/2) + self.view.bounds.height/3 * (scrollProgress),self.sizeForLabel(self.scrollIndex).width,self.sizeForLabel(self.scrollIndex).height)
                atitleLabel2.text = albumData[self.scrollIndex].title
                atitleLabel2.alpha = 1 + scrollProgress * 4
                
                
                scrollView.userInteractionEnabled = false
                
            }
            
        }
        
    }
    
    
    //MARK:***AVPlayer 间隔观察
    func updateTimetoTimeMarker(){
        
        //右下角当前时间 & 滑块观察
        secondObserver = player.addPeriodicTimeObserverForInterval(CMTimeMake(60,60), queue: nil) { (time:CMTime) -> Void in
            
            
            let asset = AVURLAsset(URL: albumData[self.scrollIndex].songurl)
            let audioDuration = asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            let value2 = Double(audioDurationSeconds)
            
            //let nowtime = self.player.currentTime()
            
            if self.sliderNowValue == 0{
                
                if self.sliderIsDragging == false{
                
                let floatnowtime = Float(CMTimeGetSeconds(self.player.currentTime()))
                let floatalltime = Float(CMTimeGetSeconds(audioDuration))
                let slidershouldbe = floatnowtime / floatalltime;
                
                self.secondValue = Double(slidershouldbe) * value2
//              self.customSlider.value = slidershouldbe 
//              可以解开注释看看效果
                UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                        
                        () -> Void in
                        
                        self.customSlider.setValue(slidershouldbe, animated: true)
                        }, completion: { (finished) -> Void in
                    })
                }
            }
            
            self.timerWatch()
            
        }
        
        //总时间
        durationObserver = player.addPeriodicTimeObserverForInterval(CMTimeMake(60,60), queue: nil) { (time:CMTime) -> Void in
            
            //print(self.player.currentItem?.duration.value)
            
            let asset = AVURLAsset(URL: albumData[self.scrollIndex].songurl)
            let audioDuration = asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            
            self.totalValue = Double(audioDurationSeconds)
            self.player.removeTimeObserver(self.durationObserver)
        }
        
    }
    
    //MARK:AVPlayer 秒表
    func timerWatch(){
        
        if secondValue < 0{
            secondValue = 0
        }
        
        
        if Int(floor(self.secondValue - 60 * floor(self.secondValue/60))) < 10{
            secondSecond = String("0\(Int(floor(self.secondValue - 60 * floor(self.secondValue/60))))")
        }
        else{
            secondSecond = String(Int(floor(self.secondValue - 60 * floor(self.secondValue/60))))
        }
        
        secondMinute = String(Int(floor(self.secondValue/60)))
        
        if Int(floor(self.totalValue - 60 * floor(self.totalValue/60))) < 10{
            totalSecond = String("0\(Int(floor(self.totalValue - 60 * floor(self.totalValue/60))))")
        }
        else{
            totalSecond = String(Int(floor(self.totalValue - 60 * floor(self.totalValue/60))))
        }
        
        totalMinute = String(Int(floor(self.totalValue/60)))
        
        self.timeMaker1.text = "0\(secondMinute):\(secondSecond)/0\(totalMinute):\(totalSecond)"
    }

    //MARK:AVPlaye Play Pause Btn Action
    func tappedPP(sender:UITapGestureRecognizer){
        if player.rate == 1.0 {
            player.pause()
            playPauseImageView.image = UIImage(named: "Play")
        }
        else{
            player.play()
            playPauseImageView.image = UIImage(named: "pause")
        }
    }
    
    //MARK:AVPlaye Slider Action
    func sliderValueDidChange(sender:UISlider!)
    {
        sliderNowValue = sender.value
        
        if self.sliderNowValue != 0{
            
            self.player.seekToTime(CMTimeMake(Int64(self.sliderNowValue * Float(self.totalValue)) , 1), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { (Bool) -> Void in
                self.player.play()
                self.playPauseImageView.image = UIImage(named: "pause")
                self.sliderNowValue = 0
                
            })
        }
        
    }
    
    func sliderTouchDragEnter(sender:UISlider!){
        self.sliderIsDragging = true
    }
    
    func sliderTouchDragExit(sender:UISlider!){
        self.sliderIsDragging = false
    }
    
    
    
    
}