# Requirements 
This application was tested against Ruby 2.2.2. To ensure maximum compatibility run the application against Ruby 2.2.2.

# Installation
To install the application clone `https://github.com/robertfall/twitter-example.git` into a folder. 

Navigate to the installation folder and run `./bin tweeter`.

The application uses the system Ruby found at `/usr/bin/ruby`. To run the application with a different instance of Ruby run `ruby bin/tweeter` from the installation directory.

# File Locations
The application attempts to find the `users.txt` and `tweets.txt` files in the current directory. To run the application with files in other locations you can pass the path in as arguments: `bin/tweeter path/to/users.txt path/to/tweets.txt`

NOTE: Assumptions have been documented in the code as comments.
