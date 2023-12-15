# AppleTrade

## [Click here to watch the video of the app](https://youtu.be/NTovu1KqQWQ)


AppleTrade, an **e-commerce application** developed using Apple products with the **SwiftUI and Combine** frameworks.**The application performs data fetching, storage, and authentication processes using Firebase. The Combine framework is used to manage asynchronous operations and publishers.** 
The authentication page manages user authentication processes with Firebase Authentication, while the main page fetches and displays product data from Firebase. The detail page shows product details and can save them to Firebase Firestore. The favorites page manages the user's favorite products and retrieves data from Firestore. The cart page retrieves, deletes, calculates the total price, and applies discounts to the shopping cart list from Firebase Firestore. SwiftUI defines the user interface using a declarative language. Behind each page, there are custom classes and models, allowing the application logic to be managed modularly. The user interface provides an interactive and user-friendly experience using the features of SwiftUI.

This application is an iOS application built on the foundation of the **MVVM architecture**

## Sign Up & Log In Screen

<p align="center">
  <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/c6f5a92b-b35d-4dcb-945c-b252da91f80e" alt="zyro-image" width="200" height="450" />
    <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/4d589981-d477-422d-b92f-751a665ebabc" alt="zyro-image" width="200" height="450" />
    <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/cf402093-b0ae-44f2-bfa4-8a0c61c154df" alt="zyro-image" width="200" height="450" />
    <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/7ff9a615-df2c-40bb-b6eb-5dce4871910a" alt="zyro-image" width="200" height="450" />
    <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/4f1eafc6-411f-41f3-a2bd-603f64c4fb05" alt="zyro-image" width="200" height="450" />
    <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/fece7bab-5cac-4c4c-8aed-6383079754b2" alt="zyro-image" width="200" height="450" />
    </p>
A user authentication screen is created using the SwiftUI and Combine frameworks.

### Functionalities

**AuthNetworkManager Class**
- Manages user creation and login processes with Firebase Authentication.
- **The createUser function** creates a new user on Firebase with the given email and password.
- **The signInUser function** logs in a user on Firebase with the provided email and password.
- Returns an **AnyPublisher** using the Combine framework, which is used for asynchronous operations.

**User Structure**
Represents the user's email and password.

**AuthViewModel Class**
- Acts as an intermediary between the user interface and business logic.
- Tracks changes using the **Combine framework** and updates the UI in response to these changes.
- Email and password validation rules, as well as user creation and login processes with Firebase, are handled here.
- **The isValidEmail and isValidPassword functions** enforce email and password validation rules.

**AuthView**
Represents the SwiftUI view that creates the user interface.
Collects email and password information from the user.
Initiates the relevant processes by clicking the "Log In" or "Sign Up" buttons.
Responds to changes from the ViewModel using **@Published** properties combined with Combine.
Uses **alerts** to display informational messages to the user.

## Main Screen

<p align="center">
  <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/8dcdeb79-adee-43b7-8c6b-03d2d4696b16" alt="zyro-image" width="200" height="450" />
    <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/0413a9eb-3652-4083-9c34-f77daaeb39e6" alt="zyro-image" width="200" height="450" />
      <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/a3d8290c-71ca-4257-be82-09b6953820f8" alt="zyro-image" width="200" height="450" />
    </p>
    
Retrieving product data using Firebase, it creates a list based on this data and provides a screen displaying details for each product. Additionally, it downloads and displays product images from Firebase Storage.

### Functionalities

**Model (Product)**
A data model representing products. Each product is defined as an object with an identifier (id), name, colors, and other attributes.

**NetworkManager (MainNetworkManager)**
- A network management class used to fetch data from Firebase and download images.
- **The fetchDataFromFirebase function** retrieves product data for a specific category. 
- **The downloadImage function** downloads an image from a URL.

**ViewModel (MainViewModel)**
- A ViewModel that handles the application logic and Firebase data. 
- **The fetchAndPrintDataFromFirebase function** retrieves product data and downloads images for the selected category.

**Views (MainView, ProductView, ProductDetailView)** 
- Views used by SwiftUI. 
- **The MainView** displays product categories and lists products for the selected category. 
- **ProductView** represents each product category. 
- **ProductDetailView** displays details and images for each product.

It also supports adding data to Firestore. Clicking on the Apple logo on a product detail screen adds the product to the list of favorite products on the favorites page.

**Notes**
- Data fetching and storage operations are performed using Firebase.
- The Combine framework is utilized to manage asynchronous operations and publishers.
- SwiftUI defines the user interface using a declarative language.
- Data fetching and image downloading operations are carried out asynchronously and managed using Combine.


## Favorite Screen

<p align="center">
  <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/217d3ae9-0df3-427d-822e-50e72a590700" alt="zyro-image" width="200" height="450" />
    <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/99c5eaa5-6184-4b93-87ff-0795791e87ff" alt="zyro-image" width="200" height="450" />
      <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/556d48d7-6065-41aa-858f-20a761852e91" alt="zyro-image" width="200" height="450" />
    </p>

    
Creating a page that manages a list of favorite products using **SwiftUI and the Combine framework**.

### Functionalities

**FavNetworkManager**
- A network manager class used to fetch data from Firestore. 
- **The fetchDataFromFirestore function** is employed to retrieve documents from a specific collection in the database.

**FavoriteProduct** 
- Represents the model for favorite products. It conforms to the Identifiable protocol, ensuring each product has a unique identifier.

**FavoriteListViewModel**
- A view model class that manages favorite products. It includes functions for fetching data from Firestore, deleting products, downloading images, and managing selected products.
- ***toggleSelection:*** Manages whether a product is selected or not.
- ***deleteSelectedProducts:*** Deletes selected products.
- ***fetchFavoriteProductsFromFirestore:*** Fetches favorite products from Firestore.
- ***downloadProductImage:*** Downloads product images from Firestore Storage.
- ***deleteFavoriteProduct:*** Deletes a specific product from Firestore and the image list.

**FavoriteListView**
- A view created by SwiftUI. It uses the List to display data and facilitate user interaction. 
- Additionally, it contains buttons to delete products and remove selected items.

**Notes**
- The view utilizes the **FavoriteListViewModel class** and displays favorite products. 
- Each product is accompanied by an image, product name, and a button for deletion.
- Additionally, it provides interactive features to mark and delete selected products. In the view, a button has been added using **navigationBarItems** to confirm the deletion process.

## Product Detail Screen

<p align="center">
  <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/d351bb37-b423-4de4-b214-7351612528ca" alt="zyro-image" width="200" height="450" />
    <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/34e9d055-5003-4f0a-8e94-98e294a4fa50" alt="zyro-image" width="200" height="450" />
      <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/fd27e621-e242-4a02-a9ec-5088d37d6aea" alt="zyro-image" width="200" height="450" />
      <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/ddbf09b2-6085-4da5-b393-2429a4cf0741" alt="zyro-image" width="200" height="450" />
      <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/6472c8fb-e876-4e68-89b8-987f71c84ce6" alt="zyro-image" width="200" height="450" />
      <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/e1462b82-8022-40a8-99b1-f99228794c3a" alt="zyro-image" width="200" height="450" />
    </p>


This page is used to display product details and store information related to these details in Firebase Firestore.

### Functionalities

**DetailNetworkManager** 
- This class, which interacts with Firebase Firestore, is used to save information about a specific product to Firestore. 
- **The saveDataToFirestore function** adds a dictionary containing information such as the product name, selected color, chosen values, and price to Firestore.

**DetailViewModel**
- This class manages the details of the product to be displayed. 
- It includes attributes such as the product name, characteristics, product image, selected color, chosen values, and filtered keys. 
- It also calls **the saveDataToFirestore function*** to save data to Firestore.

**DetailView** 
- This structure represents the view on the SwiftUI side, displaying product details and containing a button to save the selected color and values to Firestore. 
- Additionally, it shows the product image, attributes, and additional information.

**Notes**
- **The saveDataToFirestore function** uses the **DetailNetworkManager** to add data to Firestore and manages this process asynchronously using the Combine framework.

- **The DetailView** structure organizes product details in a neat manner using SwiftUI's List and Section structures. The selected color and values chosen by the user are displayed in subsections along with their corresponding keys, and these values are saved to Firestore.

- The use of Combine for adding data to Firestore is notable. The **sink function** listens to the asynchronous process's status and result.

- At the bottom of the DetailView, an information bar is displayed, containing items such as the user-selected color, price, and additional details.

## Cart Screen
 
 <p align="center">
   <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/dba81701-c749-4d15-968b-2162f454fa2b" alt="zyro-image" width="200" height="450" />
   <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/0726cf9e-a1db-41cb-82a6-b170d82c31a5" alt="zyro-image" width="200" height="450" />
   <img src="https://github.com/oykuhazer/AppleTrade/assets/130215854/1acf0f72-7335-47a0-9836-ce7124c51132" alt="zyro-image" width="200" height="450" />
    </p>

 The page that manages a shopping cart list using the SwiftUI and Combine frameworks.

### Basic Structures and Classes

- **CartItem:** A structure (struct) representing an item in the shopping cart.

- **NetworkManager:** A class that fetches and deletes shopping cart items from the "cartItems" collection on Firestore. Manages asynchronous operations using Combine.

1. ***fetchCartItems function:*** Asynchronously retrieves shopping cart items from Firestore, utilizing the Combine framework to manage this process with the **Future and sink operators**.
2. ***deleteCartItem function:*** Asynchronously deletes a shopping cart item from Firestore, also managed using Combine.

- **CartListViewModel:** A ViewModel class that manages shopping cart data. Interacts with the NetworkManager, calculates the total price in the shopping cart, and applies discounts.

***applyDiscount function:*** The discount application process is carried out using Combine. A value is emitted using the Just operator, and then this value is observed with the sink operator.

- **CartListView:** A shopping cart view created by SwiftUI. It is connected to the ViewModel and displays items in the shopping cart to the user.

1. ***onAppear block:*** When the screen appears, the fetchCartItems function is called using SwiftUI's lifecycle event onAppear. This allows for the asynchronous initiation of the data retrieval process using Combine.
2. ***Sink Operator for Button:*** The operation that occurs when the "Apply Discount" button is clicked is managed using Combine. This enables the asynchronous execution of the discount application process.

### Functionalities

- ***fetchCartItems:*** A function that retrieves shopping cart items from Firestore.
- ***deleteCartItem:*** A function that deletes a specific shopping cart item from Firestore.
- ***convertPriceStringToDouble:*** A helper function that converts a price in string format to a double with two decimal places.
- ***updateTotalPrice:*** A function that updates the total price in the shopping cart.
- ***applyDiscount:*** A function that applies a discount and updates the discounted total price.
- ***calculateAdditionalPrice:*** A function that calculates additional prices for items in the shopping cart.
- ***downloadProductImage:*** A function that downloads a product image from Firebase Storage.

**SwiftUI View (CartListView)**

- A list view displaying items in the shopping cart.
- Custom cells showing information such as image, product name, selected values, price, selected color, etc., for each item.
- Added a swipe action allowing the user to swipe right to delete an item.
- A bottom section displaying the total price, discount amount, and discounted total price.
- A button labeled "Apply Discount" to apply discounts.
