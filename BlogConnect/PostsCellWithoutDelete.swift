//Tzachi
import UIKit

class PostsCellWithoutDelete: UITableViewCell {

    
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var userNameLBL: UILabel!
    
    @IBOutlet weak var tagsLBL: UILabel!
    
    @IBOutlet weak var descrLBL: UILabel!
    
    @IBOutlet weak var dateLBL: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            titleLBL.font = UIFont.boldSystemFont(ofSize: 18)
            descrLBL.numberOfLines = 0
            self.contentView.layer.cornerRadius = 10
            self.contentView.layer.masksToBounds = true
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            if selected {
                contentView.backgroundColor = UIColor.lightGray
            } else {
                contentView.backgroundColor = contentView.backgroundColor
            }
        }

        // Method to configure the cell with a Post object
        func configure(with post: Post) {
            titleLBL.text = post.title
            userNameLBL.text = post.userName
            tagsLBL.text = post.category.rawValue
            descrLBL.text = post.description
            
            // Format and display the timestamp
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateLBL.text = dateFormatter.string(from: post.timestamp)
        }
    }
    
    

