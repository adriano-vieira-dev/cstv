# CSTV
CSTV is an app that displays stats for CS: GO matches happening worldwide.
This app uses [PandaScore](https://pandascore.co/) API as data source.

### Previews
![Main View](https://github.com/user-attachments/assets/b5052de3-0c53-4ab3-80fb-44cc6030941c)
![Detailed View](https://github.com/user-attachments/assets/4a8760bd-ff79-481e-9d2b-4ef03141c8b2)

### How to run the app
1. Clone this git project: https://github.com/adriano-vieira-dev/cstv
2. Add your PandaScore API KEY to the Environment Variable named `PANDA_SCORE_API_KEY` in the schema.
3. Run the app

### External Tools
* [SDWebImageSwiftUI]([github.com/SDWebImage/SDWebImageSwiftUI.git](https://github.com/SDWebImage/SDWebImageSwiftUI.git)): Image loading/caching

### Features
* Pagination: CSTV will load 20 matches per page, but this can be modified changing the constant named `PAGE_SIZE`. The list keeps track of the current page and will load the next page as soon as the user scroll to the end of the list.
* Pull-to-refresh: When the user pulls to refresh, the list will load the first page, and all previously loaded matches will be removed.
* Images are cached using the `SDWebImageSwiftUI` library.

### Known issues and caveats 
* The API sometimes returns a `not_started` status even though the match's `beginAt` date already passed, for this reason I chose to compare it with `Date.now` in order to show this status.
* The API sometimes returns a empty String for the series name, when this happens I only show the league name.
* The API sometimes returns a empty list of players for a team, for this reason I chose to display a Label "Empty List"

### What would I have done if I had more time?
* Localization
* Smoother animations
* Expanded details to show more information available from the API
* Sound and haptic feedback
* Unit Tests
