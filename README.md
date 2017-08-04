# Quizzily

Quizzily creates games from your flashcards on Quizlet

A Swift app using [Quizlet's API](https://quizlet.com/api/2.0/docs) and Core Data to create quizzes.

![Screenshot of Quizzily](https://github.com/AcroMace/quizzily/blob/gh-pages/img/truefalse.png)

## Running

1. [Get a Quizlet API key](https://quizlet.com/api/2.0/docs)
2. Copy `Keys.example.xcconfig` to `Keys.xcconfig` and replace `YOUR_API_KEY_HERE` for `QUIZLET_KEY` in the file with your API key from step 1
3. (*Optional*) You could also get a [Smooch API key](https://smooch.io) and repeat step 2 for `SMOOCH_KEY` in order to enable in-app customer support
4. Clean build folder / clear derived data (`⌥⇧⌘K`)
5. Run the app
