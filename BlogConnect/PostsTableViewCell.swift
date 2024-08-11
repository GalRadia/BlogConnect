import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var userNameLBL: UILabel!
    
    @IBOutlet weak var tagsLBL: UILabel!
    
    @IBOutlet weak var descrLBL: UILabel!
    
    
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            titleLBL.font = UIFont.boldSystemFont(ofSize: 18)
            descrLBL.numberOfLines = 0
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
           contentView.backgroundColor = selected ? UIColor.lightGray : UIColor.white
        }

    func configure(with post: Post) {
            titleLBL.text = post.title
            userNameLBL.text = post.userName
            tagsLBL.text = post.category.rawValue // הצגת הקטגוריה במקום תגיות
            descrLBL.text = post.description
        }
    }
