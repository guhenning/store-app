import 'package:flutter/material.dart';
import 'package:store/components/gradient_colors.dart';
import 'package:store/utils/app_route.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const GradientColors(),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(
              AppRoutes.authOrHome,
            );
          },
        ),
        title: Text(
          'How To Use',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      // to do about us
      body: const SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child:
                        Text('Tutorial 2 for Loading the products from URL')),
                //Center(child: Text('Create a Url for Loading the products')),
                Center(child: Text('Step 2.1 - Create the Json product list')),
                Center(child: Text('Use the json format bellow:')),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('''
                        {
                          "products": [
                    {
                          "id": "Check bellow for info creating the id",
                          "name": "Your Product Name",
                          "description": "Your Product Description",
                          "storeName": "Your Store Name",
                          "price": 0.0,
                          "imageUrl": "YourImageUrl"
                    }
                          ]
                        }
                        '''),
                  ),
                ),
                Center(
                  child: Text(
                      'For More produts add the comma " , " before the next one, Exemple: '),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('''
 {
                    "products": [
                      {
                        "id": "Check bellow for info creating the id",
                        "name": "Your Product Name",
                        "description": "Your Product Description",
                        "storeName": "Your Store Name",
                        "price": 0.0,
                        "imageUrl": "YourImageUrl"
                      },
                      {                 
                        "id": "Check bellow for info creating the id",
                        "name": "Your Product Name",
                        "description": "Your Product Description",
                        "storeName": "Your Store Name",
                        "price": 0.0,
                        "imageUrl": "YourImageUrl"
                      },
                      {
                        "id": "Check bellow for info creating the id",
                        "name": "Your Product Name",
                        "description": "Your Product Description",
                        "storeName": "Your Store Name",
                        "price": 0.0,
                        "imageUrl": "YourImageUrl"
                      },
                      {
                        "id": "Check bellow for info creating the id",
                        "name": "Your Product Name",
                        "description": "Your Product Description",
                        "storeName": "Your Store Name",
                        "price": 0.0,
                        "imageUrl": "YourImageUrl"
                      }
                    ]
                  }
                  '''),
                  ),
                ),
                Center(
                  child: Text(
                      'Note that in the last one don\'t have the comma " , ":'),
                ),
                Center(child: Text('Step 2.2 - Create the Product Unic ID')),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('''
                  How to create id //To do
                  '''),
                  ),
                ),
                Center(
                    child: Text(
                        'Step 2.3 - Upload the json to the web and get the raw link ')),
                Center(child: Text('Here is a example of how to do in GitHub')),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('''
          Uploading a JSON Code to GitHub - Step-by-Step Guide
          
          1. Create a GitHub account:
             - Go to the GitHub website (https://github.com).
             - Click on the "Sign Up" or "Register" button.
             - Fill in the required information, such as your username, email address, and password.
             - Complete the account creation process by following the instructions provided.
          
          2. Create a new repository:
             - After logging in to your GitHub account, you'll be directed to the dashboard.
             - Click on the "New repository" or "New project" button.
             - Provide a name for your repository and choose whether it should be public or private.
             - Optionally, add a description and initialize the repository with a README file.
             - Click on the "Create repository" or "Create project" button to create the repository.
          
          3. Upload the JSON file:
             - Once your repository is created, you'll be taken to the repository's page.
             - Look for the "Upload files" or "Add file" button.
             - Click on it to open the file upload interface.
             - Drag and drop your JSON file into the designated area or click on the area to manually select the file from your computer.
             - Wait for the upload to complete.
          
          4. Commit changes:
             - After the file is uploaded, you'll see the file's name and details in the repository.
             - Enter a short and meaningful description in the "Commit message" or "Summary" field.
             - Optionally, provide a more detailed description of the changes made.
             - Click on the "Commit" or "Save changes" button to commit the changes to the repository.
          
          5. Obtain the raw link:
             - Go to the repository's main page.
             - Navigate to the JSON file you uploaded.
             - Click on the file to open its contents.
             - Look for a "Raw" button or a "Raw" option in the file viewer.
             - Right-click on the "Raw" button or link and select "Copy link address" or a similar option.
             - The copied link address is the raw link to your JSON file on Git.
          
          Congratulations! You have successfully created a GitHub account, uploaded a JSON file to a repository, and obtained the raw link for the JSON file.
          '''),
                  ),
                ),
                Center(
                    child: Text(
                        'Step 2.4 - Use the copied json raw link to load the products')),
                Card(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Click in the Icon to open the menu'),
                      FlutterLogo(),
                      Text('Enter in the Products Manager Tab'),
                      FlutterLogo(),
                      Text('Click in the + icon'),
                      FlutterLogo(),
                      Text('Click in the disket icon'),
                      FlutterLogo(),
                      Text('Paste your Json Raw Url'),
                      FlutterLogo(),
                      Text('Click the Load button'),
                      FlutterLogo(),
                      Text('This is the message if loaded successfully'),
                      FlutterLogo(),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
