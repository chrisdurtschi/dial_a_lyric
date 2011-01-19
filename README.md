Dial-a-Lyric
============

Have a robot call your friends and recite song lyrics. [Try it!](http://dial-a-lyric.heroku.com/)

Usage
-----

First, you'll need a place to host the app.  [Heroku](http://heroku.com/) is a good choice.
Next, get a [Tropo](https://www.tropo.com/) account and create an application.
Set the voice URL of the application to http://yourhost.com/calls/initiate.json
Set your Tropo outbound voice token to TROPO_VOICE_TOKEN environment variable.
You should be good to go!
