My app, tentatively called "Moodify", utilizes the Spotify API to gather data on a user's top tracks as well as their playlists. This works by accessing a Authorization Code via Spotify's SDK, which allows us to access data for a signed in user. This was easily implemented using the SpotifyLogin CocoaPod.

Bar graphs give visual representations of the data gathered from the music, such as "danceability", "energy", and "mood", all of which are song features that are able to be retrieved for a particular song via Spotify's API.

My app includes multiscreens via a tab controller, as well as a push-able playlist view controller from the playlists screen.

A CollectionView is used to list playlists, and a TableView is used to list the tracks of a selected playlist.

Some complex components that I have included are: a tab bar, implementing custom UI animations, UIRefreshControl, and an extensive use of Spotify's API.

One feature that I didn't get to is the "Create" feature, which in the future could hopefully create playlists based on the user's inputs on various sliders. Currently the "Create" button in the tab's navigation bar adds an empty playlist to the user's Spotify. 

One issue that I have with the app is the long loading time of the playlists view, however I found that it was more efficient to load all images for each playlist to ensure smooth scrolling of the CollectionView. 