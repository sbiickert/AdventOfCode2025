# AdventOfCode2025
Solutions for AoC 2025

## Getting Ready

We know that 2025 will feature a cut-down number of puzzles: 12 instead of 24 and a half. That will mean one of two things: either twelve daily puzzles starting on the first, or maybe a different cadence like every other day. I'm expecting that I will be more likely to solve puzzles in multiple languages this year, so I'm setting a bunch up:

- [F#](https://dotnet.microsoft.com/en-us/languages/fsharp): functional .NET programming
- [Objective-C](https://code.fandom.com/wiki/Objective-C): Smalltalk-based object-oriented programming
- [Raku](https://raku.org): Next-generation Perl-based language
- [Swift](https://www.swift.org): Apple's modern language, set up in [Swift Playground](https://developer.apple.com/swift-playground/)
- [Pharo](https://pharo.org): A modern Smalltalk implementation

I have solved complete years in each of these languages, including "first solves" for all but F# and Smalltalk. I did 2020, 2021 and 2023 in Swift (2020 in Swift Playground in Xcode and 2023 in Swift Playground on my iPad Pro) and I did 2024 in Raku. Going back into the backlog, I did 2016, 2017 and 2018 in Objective-C, and I've done a full solve of 2015 in F#. I only learned F# earlier this year and haven't used it for a "first solve". I only started Smalltalk last month. I solved the first 13 days of 2020 with it without any trouble.

### Some Potential Alternates

If I was going for the gusto, I'd pull out my G4 PowerBook and use CodeWarrior and C++98. But I don't think I'm that masochistic. I did a partial solve of 2020 with C++ and got frustrated.

Speaking of masochistic, I discovered [Uiua](https://www.uiua.org) about a month ago. This array-based language uses glyphs instead of names for functions and it blows my mind. If functional programming gave me fits, then this is the next level. For example, this is a fully-operational solution for an AoC puzzle:

```P₂   ← /+×⊃(≡/+⊞=°⊟|⊢)⍉```

Part of me wouldn't mind doing this in Python. I've done a lot of Python lately with my pygissim project, and by using at with strong typing of variables and VS Code, I haven't gone crazy. But Python and VS Code is how most people solve AoC, and I don't want to be most people.

I've also got language-specific setups for Perl, PHP, Pascal and Ruby. Pascal in MPW would be a feat.

### Day 4 Complete

Thanks to the shortened event this year, we're already 1/3 done. Yesterday was the first puzzle where it took me a long time to figure out how to solve it. Then the problem was compounded by my solution working on the test data and not on the real input. Got it in the end, and I was thankful that day 4 was a 2D grid problem.

So far, all of the "solves" have been in [Smalltalk](https://github.com/sbiickert/AdventOfCode2025-Pharo) with three additional solves on day 1 (F#, ObjC, Raku) and two on day 2 (F#, Raku). Since I only got my second star for day 3 this morning and managed to squeeze out day 4 before work, I don't have any additional solves for these days yet. The Christmas party is tonight, but I have tomorrow off, so we'll see how I fare on the day 5 solve.

### Day 12: Falling Apart

Now that all of AoC 2025 is visible: we can see the arc of the challenge. Normally, there is a ramp up over the first 8-10 days, then a long false flat with some spikes in difficultly and then at least one or two "death puzzles" in the last few days. This year, it was a ramp up, then an impossible math problem on day 10, and two NP-hard puzzles on day 11 and 12.

Normally, I solve the impossible math problem by finding a solution on Reddit and translating it to my solution language. However, this year the problem appears to require a specific kind of linear algebra solver and trying to get that into Smalltalk is a big ask. I worked hard on day 11, but even running overnight I only solved part of the problem. I need to re-think the approach. Day 12 I haven't even started yet. I've come down with a cold this morning which is not helping my mood.

Since this is the end of AoC 2025, it's not like I've fallen behind on day 12 with 13 more to go. I expect I will push through over the next few days and finish. But I might put Smalltalk aside. It's been a cool experiment, but it's the editor that makes it painful. I haven't had an "explorer"-style code editor since [PowerBuilder](https://en.wikipedia.org/wiki/PowerBuilder) or [REALbasic](https://macintoshgarden.org/apps/realbasic-1x-2x-3x-4x-5x) and I had the same frustration: instead of a large code editor with many functions, there is a small view for only the current function that you've selected. It can make editing feel like a click-fest as you're jumping back and forth, and you need to save your "tabs" as you go.

I think I might pick up F# (currently complete to day 4) and run through days 5 to 9 and then handle 10, 11 and 12. 