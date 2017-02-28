# Project 4 - TwitterS

TwitterS is a simplified Twitter app displaying your home timeline tweets using [Twitter API](http://http://dev.twitter.com).

Time spent: 6 hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign in using OAuth login flow
- [X] User can view last 20 tweets from their home timeline
- [X] The current signed in user will be persisted across restarts
- [X] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [X] Retweeting and favoriting should increment the retweet and favorite count.

The following **optional** features are implemented:

- [X] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [X] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [X] User can pull to refresh.

The following **additional** features are implemented:

- [X] UI Customization
- [X] Changing the retweet and favorite button if the tweet was retweeted or favorited by the user
- [X] Alert window pops out when there is an error occure

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. As from the tutorial video, it is teaching us to use NS type of variable and why?
2. Shouldn't we put the "1.1" in the baseUrl instead of having it in the all the get and post url?

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![Screenshot](walkthrough.gif)

Walkthrough recorded by QuickTime Player.

## Notes

- Keep having "Request failed: forbidden (403)" since it reach the limit of the API, spent 1 hour waiting for that.
- I am wonder if the api return the data in real time cause it is a bit different with what I saw on my twitter app on my phone.

## License

    Copyright 2017 Chi Hon Law

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.4001011013303120.1

