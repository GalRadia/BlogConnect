import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var userNameLBL: UILabel!
    
    @IBOutlet weak var tagsLBL: UILabel!
    
    @IBOutlet weak var descrLBL: UILabel!
    
    @IBOutlet weak var dateLBL: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var onDeleteButtonTapped: (() -> Void)?

    // Called when the cell is loaded from the Storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configure the cell's UI elements
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

    // Method to configure the cell with a Post object and control the visibility of the delete button
    func configure(with post: Post, showDeleteButton: Bool) {
        titleLBL.text = post.title
        userNameLBL.text = post.userName
        tagsLBL.text = post.category.rawValue
        descrLBL.text = post.description
        
        // Format and display the timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLBL.text = dateFormatter.string(from: post.timestamp)
        
        // Control the visibility of the delete button
        deleteButton.isHidden = !showDeleteButton
    }
    

    // Action method for the delete button
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        onDeleteButtonTapped?() // Trigger the delete action
    }
}
