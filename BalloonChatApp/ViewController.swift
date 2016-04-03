//
//  ViewController.swift
//  BalloonChatApp
//
//  Created by Jeong YunWon on 2016. 3. 12..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import Cocoa
//import BalloonChat

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


class BalloonTextCellView: BCBalloonTextCellView {

    override func awakeFromNib() {
        super.awakeFromNib()
        let view = self.balloonView
        view.autoresizeToFit = true
        view.textView.automaticLinkDetectionEnabled = true
        view.backgroundImage = NSImage(named: "BalloonSampleLeft")!
        view.backgroundCapInsets = NSEdgeInsets(top: 8.0, left: 16.0, bottom: 27.0, right: 8.0)
        view.contentInsets = NSEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 8.0)
    }
}


class ChatViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet var tableView: BCBalloonTableView! = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(self.tableView != nil)
        self.tableView.columnIndexToFitWhenResizing = 0
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 100;
    }

    func _resize(view: BCBalloonTextCellView) {
        var frame = view.balloonView.frame
        let baseWidth = self.tableView.frame.size.width
        frame.size.width = baseWidth * 3 / 4
        view.balloonView.frame = frame
    }

    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let view: BCBalloonTextCellView = tableView.makeViewWithIdentifier("cell", owner: self) as! BCBalloonTextCellView
        _resize(view)
        view.balloonView.string = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        let height = view.balloonView.sizeThatFits(view.frame.size).height
        return height
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view: BCBalloonTextCellView = tableView.makeViewWithIdentifier("cell", owner: self) as! BCBalloonTextCellView
        _resize(view)
        view.balloonView.string = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        return view
    }
}

