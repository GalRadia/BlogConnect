# BlogConnect

BlogConnect is a dynamic iOS application that allows users to share and engage with blog posts across various categories. Utilizing Firebase for robust authentication and data management, BlogConnect offers a  interactive platform for users to express their thoughts and ideas.

## Features

- **Multiple Authentication Options**: Users can sign in through Firebase, SMS, or Google authentication methods.
- **Personalized Profiles**: Each user can set up a display name that is shown on their posts.
- **Post Creation and Deletion**: Users have the ability to create new posts, categorize them, and delete their own posts.
- **Community Engagement**: All users can read posts from other users, fostering a community environment.
- **Category-Based Navigation**: Each post is assigned a category, and users can search for posts based on these categories, enhancing the navigational experience.
- **Real-Time Data**: We utilize Firebase's Realtime Database to store and synchronize data in real time across all clients.


## Project Structure


- `HomePageViewController.swift`: Controls the home page view shows the tableView to check all the posts and search by categories.
- `InsertPostController.swift`: Manages the post insertion, add post.
- `MyProfileViewController.swift`: Manages the user profile view.
- `RegisterViewController.swift`: Controls the registration process.
- `LoginViewController.swift`: Handles user login functionalities (SMS, Google Account, Email & Password).
- `SceneDelegate.swift`: Manages app scene sessions.



## Getting Started

### Installation

Clone the repository:
```bash
git clone https://github.com/GalRadia/BlogConnect.git
```
Install dependencies with Swift Package Manager

## Usage

Log in using any of the supported methods, create, read, and manage posts through an intuitive interface designed for ease of use.

## Screenshots

### Login
<img src="https://github.com/user-attachments/assets/f15b0f25-a1a1-4b26-90ae-b84adac0fc88" alt="התחברות" width="350" height="700">

### Home Page
<img src="https://github.com/user-attachments/assets/862eaec1-908f-4df2-a6fa-840af9af2dc4" alt="home" width="350" height="700">

### Add post
<img src="https://github.com/user-attachments/assets/e44d12e5-d156-4d78-ad05-7f37181c1db9" alt="הוספת פוסט" width="350" height="700">

### My profile
<img src="https://github.com/user-attachments/assets/25f82959-2676-4c52-b0ec-317c153dd1ed" alt="הפרופיל שלי" width="350" height="700">


