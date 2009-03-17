# Cucover

Cucover is a thin wrapper for [Cucumber](http://github.com/aslakhellesoy/cucumber/tree/master) which makes it lazy.

What does it mean for Cucumber to be lazy? It will only run a feature if it needs to.

How does it decide whether it needs to run a feature? Every time you run a feature using Cucover, it watches the code in 
your application that is executed, and remembers. The next time you run Cucover, it skips a feature if the source files (or the feature itself)
have not been changed since it was last run.

## Installation and Usage

There's no gem for now, so just clone the code from github.

To run your features lazily, just use the cucover binary instead of cucumber. Use the same ommand-line options as usual, they are all passed 
directly to cucumber. No magic to see here.

## Limitations

  * Cucover uses RCov to watch the code executed by each feature. RCov does not report ERB view templates, so rails views that are touched will
not cause their features to be re-run.
  * Anything that runs out of process will not be covered, and therefore cannot trigger a re-run.
  * This is very new and experimental. There may be bugs. Feedback is welcome via github messages.