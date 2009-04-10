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

## Limitations

  * Anything that runs out of process will not be covered, and therefore cannot trigger a re-run, so if you use Cucumber to drive Selenium, for example, you're out of luck.
  * This is very new and experimental. There may be bugs. Feedback is welcome via github messages.

## Todo
  * The features for cucuover itself seem to flicker (intermittently fail). This is probably due to timing issues when figuring out if a file is dirty.
  * Consider making failing features run-run even when they're not dirty, just for the good old re-bar feel
    
## Similar 'Selective Testing' Tools

  * JTestMe
    * http://xircles.codehaus.org/projects/jtestme 
    * [Agile2008 conference submission](http://submissions.agile2008.org/node/3435)
  * Infinitest
    * http://code.google.com/p/infinitest/ 
    * Contact: [Ben Rady](http://submissions.agile2008.org/node/377)
  * Google Testar
    * http://code.google.com/p/google-testar/
    * Contact: Misha Dmitriev
  * Clover test optimization
    * http://www.atlassian.com/software/clover/features/optimization.jsp
  * JUnitMax
    * a selective testing tool by [Kent Beck](http://www.threeriversinstitute.org/blog)
    * http://junitmax.com/

