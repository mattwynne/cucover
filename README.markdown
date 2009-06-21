# Cucover

Cucover is a thin wrapper for [Cucumber](http://github.com/aslakhellesoy/cucumber/tree/master) which makes it lazy.

>> Question:
>> What does it mean for Cucumber to be lazy? 

> Answer:
> It will only run a scenario if it needs to.

How does it decide whether it needs to run a scenario? Every time you run a feature using Cucover, it watches the code in your application that is executed, and remembers. The next time you run Cucover, it skips a scenario if the source files (or the feature itself) have not been changed since it was last run.

## Features

  * Within a feature, Cucover will only re-run the Scenarios that have been affected by your changes
  * Uses RCov to map features to covered source files
  * Patches Rails to also map scenarios to covered .erb view templates
  * Shows skipped Scenarios, for confidence
  * Re-runs failing features, even when nothing has changed, for that good old red-bar feel.
  * Allows you to see which lines of a source file are tested by which scenarios

## Installation and Usage

Something like this, as I haven't figured out the dependencies yet for the gem:

    sudo gem install cucumber
    sudo gem install spicycode-rcov
    sudo gem install mattwynne-cucover

To run your features lazily, use the cucover binary instead of cucumber:

    cucover -- features/lamb_chops.feature
    
To see what Cucover has already recorded (in the cucover.data file):

    cucover --show-recordings
    
To find out which tests cover which lines of a given source file:

    cucover --coverage_of path/to/some_source_file.rb

## Limitations

  * Anything that runs out of process will not be covered, and therefore cannot trigger a re-run, so if you use Cucumber to drive Selenium, for example, you're out of luck.
  * This is very new and experimental. There may be bugs. Feedback is welcome via github messages.

## Todo
  * Proper args parsing and command-line help
  * Run code coverage and remove any slop following refactoring
  * Speed up the Rails test - maybe strip some guff out of the environment load?
  * Speed up the whole thing by only writing the recordings to disk when the process exits
    
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
