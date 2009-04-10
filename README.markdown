# Cucover

Cucover is a thin wrapper for [Cucumber](http://github.com/aslakhellesoy/cucumber/tree/master) which makes it lazy.

What does it mean for Cucumber to be lazy? It will only run a feature if it needs to.

How does it decide whether it needs to run a feature? Every time you run a feature using Cucover, it watches the code in your application that is executed, and remembers. The next time you run Cucover, it skips a feature if the source files (or the feature itself) have not been changed since it was last run.

## Features

  * Uses RCov to map features to covered source files
  * Patches Rails to also map features to covered .erb templates

## Installation and Usage

Something like this, as I haven't figured out the dependencies yet for the gem:

    sudo gem install spicycode-rcov
    sudo gem install mattwynne-cucover

To run your features lazily, just use the cucover binary instead of cucumber. Use the same command-line options as usual, they are all passed directly to cucumber. No magic to see here, just a little gentle duck-punching.

## Limitations / Issues / Todo

  * Anything that runs out of process will not be covered, and therefore cannot trigger a re-run, so if you use Cucumber to drive Selenium, for example, you're out of luck.
  * This is very new and experimental. There may be bugs. Feedback is welcome via github messages.
  * The features for cucuover itself seem to flicker (intermittently fail). This is probably due to timing issues when figuring out if a file is dirty.