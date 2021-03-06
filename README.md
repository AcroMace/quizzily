![Screenshot of Quizzily](https://github.com/AcroMace/quizzily/blob/gh-pages/img/truefalse.png)

# Quizzily

[![Build Status](https://travis-ci.org/AcroMace/quizzily.svg?branch=master)](https://travis-ci.org/AcroMace/quizzily) [![DUB](https://img.shields.io/dub/l/vibe-d.svg?maxAge=2592000)](https://github.com/AcroMace/quizzily/blob/master/LICENSE)

Quizzily creates games from your flashcards on Quizlet

A Swift app using [Quizlet's API](https://quizlet.com/api/2.0/docs) and Core Data to create quizzes.

## Running

1. [Get a Quizlet API key](https://quizlet.com/api/2.0/docs)
2. Copy `Keys.example.xcconfig` to `Keys.xcconfig` and replace `YOUR_API_KEY_HERE` for `QUIZLET_KEY` in the file with your API key from step 1
3. (*Optional*) You could also get a [Smooch API key](https://smooch.io) and repeat step 2 for `SMOOCH_KEY` in order to enable in-app customer support
4. Install Cocoapods dependencies: `pod install`
5. Open `Quizzily.xcworkspace`
6. Clean build folder / clear derived data (`⌥⇧⌘K`)
7. Run the app
