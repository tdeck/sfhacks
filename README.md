## What is this?
This is the source code for [sfhacks.com](https://sfhacks.com), a comprehensive list of all the upcoming hackathons I could find in the San Francsico bay area. These are scattered across a bunch of different places, and my friend [Shenil](https://github.com/Shenil) and I wanted them all in one place.

## How does it work?
Every day, a scheduled job pulls down listings from Eventbrite, Meetup, Devpost, and a few other places, filters out the new ones that look like they might be hackathons, and adds them to a list in my admin UI. From there, I manually review the listings and look up more info about each hackathon, then input that into the site. It's not a very fancy process technically, but it ensures that I don't end up with any duplicates or irrelevant listings.

## What can I do with this code?
This isn't the best Ruby code in the world, but it's under the [MIT license](http://troy.mit-license.org/) so you can do what you like with it. The most useful part might be the set of scrapers I've written for various sites.

## I have an idea, and somehow found your github
Go ahead and make an issue or PR!
