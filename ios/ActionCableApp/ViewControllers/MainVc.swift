import UIKit

class MainVc: UIViewController {
    private let accounts = DogName.accounts
    private let rooms = RoomName.names

    @IBOutlet weak var userSc: UISegmentedControl!
    @IBOutlet weak var roomSc: UISegmentedControl!
    
    @IBAction func tabChatButton(_ sender: Any) {
        let account = accounts[userSc.selectedSegmentIndex]
        let room = rooms[roomSc.selectedSegmentIndex]
        
        let barkNc = storyboard?.instantiateViewController(withIdentifier: "barkNc") as! UINavigationController
        let barkVc = barkNc.topViewController as! BarkVc
        barkVc.account = account
        barkVc.room = room
        self.present(barkNc, animated: true, completion: nil)
    }
}

