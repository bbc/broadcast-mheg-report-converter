# broadcast-mheg-report-converter
A ruby script for generating Comscore reports for the Broadcast Red Button service into something human-readable

## Pre-requirements
- You need to have 'bundler' installed locally for this to work
-- This can be done by using the command 'gem install bundler' (add sudo if you don't have a non-system install)
- Then navigate to the /src folder and run the command 'bundle'

## What's the point of this?
The current comscore reports for MHEG services on Broadcast Red Button only send the file paths to the particular pages you may be looking at - these are normally not human readable and difficult to attribute what page the report is referring to

## So what's this for?
Basically, this allows you to export a particular report and generate a human-readable outcome as a CSV.

## So how do I do that?
- Firstly, in Comscore, navigate to report ID 31780 (Broadcast RCs by Popularity - Browsers)
- Set the report to the period you wish to look at
- Download the file as a CSV and store it in the 'reports' folder
- Load up the terminal and navigate to the repo's src folder
- Run 'ruby report-generator.rb FILENAME.csv'
- If correct the output can be found in the src/output folder as a CSV you can import into Excel

## Anything else worth knowing?
Worth noting that the outputs here combine both Freesat and DTT numbers. However, for those pages not avaialble of both, the output will separate DTT / FSAT only pages. You would have to create a different report in DAX which discounts Freesat/DTT numbers and import that for it to be separated. I can't say if it would work ootb.

