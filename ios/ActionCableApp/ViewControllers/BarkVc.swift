import UIKit
import ActionCableClient

class BarkVc: UIViewController {
    private let CableUrl = "ws://devnokiyo.example.com/cable"
    private let ChannelIdentifier = "RoomChannel"
    private let defaultComment = ""
    
    private var client: ActionCableClient!
    private var channel: Channel!

    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    
    @IBOutlet weak var chiyoUsv: UserStatusView!
    @IBOutlet weak var eruUsv: UserStatusView!
    @IBOutlet weak var otomeUsv: UserStatusView!
    
    var account: String!
    var room: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initClient()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        client.disconnect()
    }
    
    @IBAction func tabCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBawBawButton(_ sender: Any) {
        bark(bark: "bawbaw")
    }
    
    @IBAction func tapWaooonButton(_ sender: Any) {
        bark(bark: "waooon")
    }
    
    @IBAction func tapMumblingButton(_ sender: Any) {
        subscribedAction { channel?.action("mumbling") }
    }
    
    private func initView() {
        accountNameLabel.text = NSLocalizedString(account, comment: defaultComment);
        roomNameLabel.text = NSLocalizedString(room, comment: defaultComment);
        
        chiyoUsv.icon.image = UIImage(named: DogName.chiyo.capitalized)
        chiyoUsv.name.text = NSLocalizedString(DogName.chiyo.rawValue, comment: defaultComment)
        chiyoUsv.bark.text = NSLocalizedString(SocketType.roomOut.rawValue, comment: defaultComment)
        
        eruUsv.icon.image = UIImage(named: DogName.eru.capitalized)
        eruUsv.name.text = NSLocalizedString(DogName.eru.rawValue, comment: defaultComment)
        eruUsv.bark.text = NSLocalizedString(SocketType.roomOut.rawValue, comment: defaultComment)
        
        otomeUsv.icon.image = UIImage(named: DogName.otome.capitalized)
        otomeUsv.name.text = NSLocalizedString(DogName.otome.rawValue, comment: defaultComment)
        otomeUsv.bark.text = NSLocalizedString(SocketType.roomOut.rawValue, comment: defaultComment)
    }
    
    private func initClient() {
        client = ActionCableClient(url: URL(string: "\(CableUrl)/?account=\(account!)")!)
        client.onConnected = {
            print("Connected")
            self.initChannel()
        }
        
        client.connect()
    }
    
    private func initChannel() {
        self.channel = self.client.create(ChannelIdentifier, identifier: ["room": room], autoSubscribe: false)
        self.channel.onSubscribed = {
            print("Subscribe")
            self.channel?.action("greeting")
        }
        
        self.channel.onReceive = {(data: Any?, error: Error?) in
            print("Received")            
            if let response = RoomChannelResponse(data: data) {
                let userStatusView = self.findUserStatusView(account: response.account)
                switch response.type {
                case .roomIn:
                    self.updateUserStatus(accounts: response.roommate, type: response.type)
                    userStatusView.bark.text = NSLocalizedString(response.type.rawValue, comment: self.defaultComment)
                    break
                case .roomOut:
                    userStatusView.bark.text = NSLocalizedString(response.type.rawValue, comment: self.defaultComment)
                    userStatusView.online.backgroundColor = UIColor.red
                    break
                case .mumbling:
                    if let content = response.content {
                        userStatusView.bark.text = content
                        userStatusView.rockBark()
                    }
                    break
                case .bark:
                    if let content = response.content {
                        userStatusView.bark.text = NSLocalizedString(content, comment: self.defaultComment)
                        userStatusView.rockBark()
                    }
                    break
                }
            }
        }
        
        self.channel.subscribe()
    }
    
    private func updateUserStatus(accounts: Array<String>?, type: SocketType) {
        accounts?.forEach { account in
            let usv = findUserStatusView(account: account)
            usv.bark.text = NSLocalizedString(type.rawValue, comment: self.defaultComment)
            usv.online.backgroundColor = UIColor.green
        }
    }
    
    private func findUserStatusView(account: String?) -> UserStatusView {
        switch DogName(account: account!)! {
        case .chiyo:
            return chiyoUsv
        case .eru:
            return eruUsv
        case .otome:
            return otomeUsv
        }
    }
    
    private func bark(bark: String) {
        subscribedAction {
            channel?.action("bark", with: ["content": bark])
        }
    }
    
    private func subscribedAction(action: () -> ()) {
        if channel?.isSubscribed ?? false {
            action()
        }
    }
}
