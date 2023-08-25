Summary

npm install dotenv --save

Next, add the following line to your app.

require('dotenv').config()

Then create a .env file at the root directory of your application and add the variables to it.

// contents of .env

REACT_APP_API_KEY = 'my-secret-api-key'
Finally, add .env to your .gitignore file so that Git ignores it and it never ends up on GitHub.
