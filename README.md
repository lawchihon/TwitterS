# Project - TwitterS

TwitterS is a simplified Twitter app displaying your home timeline tweets using [Twitter API](http://http://dev.twitter.com).

Time spent: 6(W1) + 10(W2) hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign in using OAuth login flow
- [X] User can view last 20 tweets from their home timeline
- [X] The current signed in user will be persisted across restarts
- [X] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [X] Retweeting and favoriting should increment the retweet and favorite count.
- [X] Tweet Details Page: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [X] Profile page:
   - [X] Contains the user header view
   - [X] Contains a section with the users basic stats: # tweets, # following, # followers
- [X] Home Timeline: Tapping on a user image should bring up that user's profile page
- [X] Compose Page: User can compose a new tweet by tapping on a compose button.


The following **optional** features are implemented:

- [X] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [X] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [X] User can pull to refresh.
- [X] When composing, you should have a countdown in the upper right for the tweet limit.
- [X] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [ ] Profile Page
   - [X] Implement the paging view for the user description.
   - [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [ ] Pulling down the profile page should blur and resize the header image.
- [ ] Account switching
   - [ ] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [ ] Swipe to delete an account


The following **additional** features are implemented:

- [X] UI Customization
- [X] Changing the retweet and favorite button if the tweet was retweeted or favorited by the user
- [X] Alert window pops out when there is an error occure
- [X] If it is replying to a tweet, it will included the reply tweet id to POST
- [X] If it is replying to a tweet, it will auto detect who is replying to and put the @ in the tweet
- [X] Disable tweet to submit when there is no content or out of limit
- [X] The tweet limit countdown will turn red once it is almost over limit

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to use nib?
2. I found that there is a lot scene have similar layout, should have different scene for each case or we should make one that is reusable?

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![Screenshot](walkthrough.gif)

Walkthrough recorded by QuickTime Player.

## Notes

- Keep having "Request failed: forbidden (403)" since it reach the limit of the API, spent 1 hour waiting for that.
- Running out of time to work on because of the school work.

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

