# DuoCast | Language learning on-the-go!

<p align="center">
  <img src="https://d112y698adiu2z.cloudfront.net/photos/production/software_photos/003/355/742/datas/gallery.jpg">
</p>

<p align="center">
  Chat page before and after generation and settings page
</p>

<p align="center">
  <img src="https://d112y698adiu2z.cloudfront.net/photos/production/software_photos/003/355/758/datas/gallery.jpg">
</p>

<p align="center">
  Light mode featuring a French to English dialogue about vacation plans
</p>

## Inspiration
Modern language learning apps all work the same way: take a random sentence in a foreign language, translate it to your native language, and repeat until you're fluent. This is no way to learn, and studies found "watching and listening content in the target language" ([Yale, 2023](https://campuspress.yale.edu/ledger/the-best-ways-to-learn-a-language-according-to-research/)) to be more effective. Oftentimes, however, this requires you to dedicate time to watch movies, TV shows, and other content. But when work, school, or life in general gets in the way, few can actually find the time to do so in the first place. Additionally, most content will stylize their language to fit the theme of their plot (would someone talk like Spongebob Squarepants out in the street?) and may sound awkward when applied to the real world.

What if there was an app that could generate conversations in both your native language and the language you want to learn in a modern, natural dialect that actually sounds like a fluent speaker for you to listen to in the background, allowing you to passively work on a new language in a 20-minute commute, a 2-hour workout, and everything beyond? Introducing DuoCast, a hands-free AI-powered mobile app for language learning on-the-go!

## What it does
DuoCast teaches new languages by AI generating a conversation in a modern, natural dialect for you to listen to.

## How we built it
We built DuoCast as a mobile app with Flutter that generates conversations with Gemini.

## Challenges we ran into
Our biggest challenge was implementing the text to speech. To keep our app as lightweight as possible, we wanted to avoid forcing you from downloading custom voice packages for every different combination of foreign and native languages. We solved this by utilizing the built-in narrator on your phone, the same voice used for Siri on an iPhone and Bixby on a Samsung.

## Accomplishments that we're proud of
Our biggest accomplishment is creating an application that employs science's most effective method for learning new languages. Gone are the days of translating random, incoherent sentences that we may never use in real life. With DuoCast, you can learn with structured, meaningful conversations that you could actually end up using.

## What we learned
This project taught us how to integrate Gemini into a Flutter app.

## What's next for DuoCast
In the future, we could include all the languages featured in Google Translate. Additionally, we could also include all the expected controls of a playback application such as pausing, playing, fast-forwarding, rewinding, etc.
