//
//  ProgressHUD.swift
//  Cartrack
//
//  Created by Aadil Majeed on 16/09/22.
//

import UIKit

class ProgressView {
    
    static let shared: ProgressView = ProgressView()
    
    private var currentView: ProgressHUD?
    
    private init() {}
    
    func loadOn(view: UIView, animated: Bool) -> Void {
        self.currentView = ProgressHUD.addOn(superView: view)
        if(animated) {
            self.currentView?.start(duration: 0.5, completion: nil)
        }
    }

    func removeFrom(view: UIView, animated: Bool) -> Void {
        guard let currentView = currentView, view.subviews.contains(currentView) else {
            return
        }
        if(animated) {
            self.currentView?.stop(duration: 0.5, completion: { [currentView] in
                currentView.removeFromSuperview()
            })
        }
    }
}


class ProgressHUD: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.statusLabel.numberOfLines = 0
        self.contentView.layer.cornerRadius = 10.0
        self.statusLabel.text = "Loading.."
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func start(duration: TimeInterval, completion: (() -> Void)?){
        self.contentView.alpha = 0
        self.contentView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
            self.contentView.alpha = 1
            self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { finished in
            completion?()
        }
    }
    
    func stop(duration: TimeInterval, completion: (() -> Void)?){
        self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            self.contentView.alpha = 0
            self.contentView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        } completion: { finished in
            completion?()
        }
    }

}

extension ProgressHUD {

    class func addOn(superView: UIView) -> ProgressHUD {
        let view = Bundle.loadView(fromNib: "ProgressHUD", withType: ProgressHUD.self)
        superView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: superView.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0).isActive = true
        return view
    }
}
