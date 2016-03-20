//
//  ViewController.swift
//  BalloonChatApp
//
//  Created by Jeong YunWon on 2016. 3. 12..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import Cocoa
import BalloonChat

class NinePartImageViewController: NSViewController {

    @IBOutlet var imageView: NSImageView! = nil;

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(self.imageView != nil)

        //let sourceImage = NSImage(imageLiteral: "BalloonSampleRight")
        //let ninePartImage = sourceImage.ninePartImageWithSize(self.imageView.frame.size, capInsets:NSEdgeInsetsMake(8.0, 8.0, 27.0, 16.0))

        //self.imageView.layer = CAANinePartImageLayer(image: sourceImage, capInsets:NSEdgeInsetsMake(8.0, 8.0, 42.0, 28.0))
        //self.imageView.setNeedsDisplay()
        //self.imageView.image = ninePartImage
    }

}

class TextViewController: NSViewController, BCBalloonTextViewDelegate {

    @IBOutlet var leftBalloonView: BCBalloonTextView! = nil
    @IBOutlet var rightBalloonView: BCBalloonTextView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(self.leftBalloonView != nil);
        assert(self.rightBalloonView != nil);

        let leftImage = NSImage(imageLiteral: "BalloonSampleLeft")
        self.leftBalloonView.delegate = self;
        self.leftBalloonView.alignment = .Left
        self.leftBalloonView.textView.font = NSFont(name: self.leftBalloonView.textView.font!.fontName, size: 16.0)
        self.leftBalloonView.autoresizeToFit = true
        self.leftBalloonView.setBalloonImage(leftImage, capInsets: NSEdgeInsetsMake(8.0, 16.0, 27.0, 8.0))
        self.leftBalloonView.contentInsets = NSEdgeInsetsMake(6.0, 16.0, 4.0, 8.0); // bottom cheating

        let rightImage = NSImage(imageLiteral: "BalloonSampleRight")
        self.leftBalloonView.delegate = self;
        self.rightBalloonView.alignment = .Right
        self.rightBalloonView.textView.font = NSFont(name: self.rightBalloonView.textView.font!.fontName, size: 16.0)
        self.rightBalloonView.autoresizeToFit = true
        self.rightBalloonView.setBalloonImage(rightImage, capInsets: NSEdgeInsetsMake(8.0, 8.0, 27.0, 16.0))
        self.rightBalloonView.contentInsets = NSEdgeInsetsMake(6.0, 8.0, 4.0, 16.0); // bottom cheating

        self.leftBalloonView.string = "Lefthand text (smile)"
        self.rightBalloonView.string = "Righthand text (special)"
    }

    func regularExpressionPatternsAndBlocksForReplacingInTextView(balloonTextView: BCBalloonTextView) -> [String : BCBalloonTextViewReplacingBlock] {
        return [
            "smile": { (_) in
                return NSAttributedString(string: "hey")
            }
        ]
    }

}

//class ChatViewController: NSViewController {
//
//    @IBOutlet var chatView: BCBalloonChatView! = nil
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        assert(self.chatView != nil)
//    }
//}

