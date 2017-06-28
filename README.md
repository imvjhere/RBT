# Country list: 

Country list App designed with simple MVC pattern, the app performs the following after app launch.

* Fetch Countries JSON from server
* Parse JSON and gets an array of countries
* Sorts the array alphabetically
* Displays the country list in tableView
* Search bar acts as filter stored countries based on search query
* Alphabet index allows user to jump to needed country.
* Added Grouping based on Alphabets
* Added cache for JSON data

Since the 'flag' key in JSON is SVG file, couldn't use caching to download flag image and cache.

Controllers: 

RBTMasterViewController:
Displays List of countries, search bar and indexing. 

RBTDetailViewController:
Displays a static table with image of flag and few data points about the selected country.

Models: 

RBTCountry:
Model containing properties of country. Helps to enumerate the data points and return nil incase of empty values in JSON for required properties.

RBTFetchDataAPI:
Model containing methods to fetch JSON and parse JSON on background thread to get necessary values and update them to fetchedCountries array (also sort the array alphabetically). Also returns errors incase of Server / Json / Network issue so the view controller can handle it.

TODO further:

* Use coredata and search controller to fetch updates.
* Unit test the models.
