//
//  Spinner.swift
//  DEVChallenge12R2
//
//  Created by " " on 6/1/18.
//  Copyright © 2018 " ". All rights reserved.
//

import UIKit

class Spinner: UIView {
    private var activityView: UIView?
    private var spinner: UIActivityIndicatorView?
    private var spinnerDidShow = NSNotification.Name("spinnerDidShow")

    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }

    convenience init(start: Bool = false) {
        self.init()
        if start { self.start() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()

        NotificationCenter.default.addObserver(forName: spinnerDidShow, object: self, queue: OperationQueue.main) { notification in
            if (notification.object as! UIView) != self {
                self.stop()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        backgroundColor = .clear
        activityView = UIView(frame: frame)
        activityView?.backgroundColor = UIColor.clear
        addSubview(activityView!)

        activityView?.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(150)
        }

        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)

        spinner = UIActivityIndicatorView()
        spinner?.color = .white
        spinner?.center = activityView!.center
        spinner?.hidesWhenStopped = true
        spinner?.transform = transform
        activityView?.addSubview(spinner!)

        spinner?.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activityView?.layer.cornerRadius = 10
        activityView?.layer.masksToBounds = true

    }

    func start() {
        if let vc = UIApplication.topViewController()?.tabBarController { spin(vc.selectedViewController!) }
        else if let vc = UIApplication.topViewController()?.navigationController { spin(vc) }
        else if let vc = UIApplication.topViewController() { spin(vc) }
        NotificationCenter.default.post(name: spinnerDidShow, object: self)
    }

    private func spin(_ vc: UIViewController) {
        guard self.superview != vc else { spinner?.startAnimating(); return }
        vc.view.addSubview(self)
        spinner?.startAnimating()
    }

    func stop() {
        spinner?.stopAnimating()
        self.removeFromSuperview()
    }
}

