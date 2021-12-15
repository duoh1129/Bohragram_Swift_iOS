

import UIKit

class ChatReceiverImage_TableCell: UITableViewCell {
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var starBtn: UIButton!
//    var delegate:PlayVideoDelegate?
    var index:Int? = nil
    var status:Bool? = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.fileImage.contentMode = .scaleAspectFill
        self.fileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func playPressed(_ sender: Any) {
//        self.delegate?.playVideo(index: index ?? 0, status: true ?? false)
        
    }
    
    func setupForNONGroup(){
        self.usernameLabel.isHidden = true
        self.viewTop.constant = 0
    }
    
    func setupForGROUP(){
        self.usernameLabel.isHidden = false
        self.viewTop.constant = 20
    }
}
