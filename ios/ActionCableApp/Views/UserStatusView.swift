import UIKit

class UserStatusView: UIView {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bark: UILabel!
    @IBOutlet weak var online: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibInit()
    }
    
    fileprivate func nibInit() {
        guard let view = UINib(nibName: "UserStatusView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        online.backgroundColor = UIColor.red
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func rockBark() {
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.bark.center.x += 20.0
        }) { _ in
            self.bark.center.x -= 20.0
        }

    }
}
