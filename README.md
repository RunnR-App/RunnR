Original App Design Project - README Template
===

# RunnR

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Track information when you're on the run, and share it with your friends. RunnR lets you connect with your friends through fitness like never before.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Fitness
- **Mobile:** Mobile only. 
- **Story:** Allows users to track their runs and share them with others. Provides aggregate data about themselves  
- **Market:** Anyone who wants to log their runs or wants a social media for running data about themselves or others. 
- **Habit:** Running is routine exercise for many people. With RunnR, users can get indepth information about their runs, encouraging them to run more and share their activity with others. 
- **Scope:** Narrow focus. Run, Social Media, and user accounts all pilled into one. Since location is central in the application, it has much to be expanded on. For example, sharing location with selected friends during runs can be used as a saftey feature for users.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] Create an account / login
- [ ] User can start and stop a run 
- [ ] Data about user personal activity / exersises
- [ ] User can add friends
- [ ] User can see friends recent workouts
- [ ] User can compare workout info with their friends

**Optional Nice-to-have Stories**

- [ ] User level. Complete objectives during workouts
- [ ] User data privacy
- [ ] Run sharing. Add friends to your runs, 

### 2. Screen Archetypes

* Login / Register - User signs up or logs into their account
    * Create an account / login
* Profile - User can view their identity and stats
    * Data about user activity / exersises 
    * User can add friends
* Map View - Often visualizing location-based information
    * User can start and stop a run
* Stream - User can scroll through important resources in a list
    * User can add friends
    * User can see friends recent workouts
    * User can compare workout info with their friends

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Stream
* Map View
* Profile

**Flow Navigation** (Screen to Screen)

* Login / Register - User signs up or logs into their account
    * Stream
* Profile - User can view their identity and stats
    * Detail
* Map View - Often visualizing location-based information
    * Detail
* Stream - User can scroll through important resources in a list
    * Detail

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.ibb.co/1fn0Wcp/IMG-0706.jpg" width=600>

## Schema 
### Models

#### Post
| Property | Type | Description |
| -------- | -------- | -------- |
| objectId     | String     | unique id for the user post (default)|
| author     | Pointer to User     | Link to post |
| image     | File     | Optional for post     |
| description     | String     | User or generated text     |
| distance     | Number     | Number of miles ran     |
| time     | DateTime     | Time spent on run     |
| createdAt     | DateTime     | Creation of post(default)     |
| updatedAt     | DateTime     | Last updated (default)     |

### Networking
- [Add list of network requests by screen ]
- PFUser
    - (Create/POST) Sign Up
    ```
    func onLogin() {
      var user = PFUser()
      user.username = "myUsername"
      user.password = "myPassword"

      // other fields can be set just like with PFObject
      user["phone"] = "415-392-0202"

      user.signUpInBackground {
        (succeeded: Bool, error: Error?) -> Void in
        if let error = error {
          let errorString = error.localizedDescription
          // Show the errorString somewhere and let the user try again.
        } else {
          // Hooray! Let them use the app now.
        }
      }
    }
    ```
    - (Read/GET) Login with cridentials
    ```
    PFUser.logInWithUsername(inBackground:"myname", password:"mypass") {
      (user: PFUser?, error: Error?) -> Void in
      if user != nil {
        self.performSeque(withIdentifier: "loginSegue", sender:nil)
      } else {
        // The login failed. Check error to see why.
      }
    }
    ```
- Home Feed
    - (Create/POST) Post a run
    ```
    func onCompleteRun(sender: Any){
        let post = PFObject(classname: "Posts")
        
        post["description"] = commentField.text!
        .
        .    // store our data
        .
        
        post.saveInBackground()
    }
    ```
    - (Delete) Remove posted run
    ```
    let query = PFQuery(className: "Posts")
    query.whereKey("objectId", equalTo: currentCellId)
    query.findObjectInBackgroundWithBlock{
        (object: Any, error: NSError?) -> Void in
            object.deleteEventually()
    } 
    
    ```
    - (Read/GET) Friend activity for main feed
    ```
    let query = PFQuery(className:"Location")
    query.whereKey("author", containedin: self.friends)
    query.order(byDescending: "createdAt")
    query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
       if let error = error { 
          print(error.localizedDescription)
       } else if let posts = posts {
          print("Successfully retrieved \(posts.count) posts.")
      // TODO: Do something with posts...
       }
    }
    ```
- Profile Screen
    - (Read/GET) Query all posts where user is author
    ```
    let query = PFQuery(className:"Location")
    query.whereKey("author", equalTo: currentUser)
    query.order(byDescending: "createdAt")
    query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
       if let error = error { 
          print(error.localizedDescription)
       } else if let posts = posts {
          print("Successfully retrieved \(posts.count) posts.")
      // TODO: Do something with posts...
       }
    }
    ```
## Sprint 1:
- [x] Application connected to parse
- [x] Login/Signup
- [x] Basic MapKit implementation

<img src="http://g.recordit.co/I1A6xqzloR.gif" width=250><br>
