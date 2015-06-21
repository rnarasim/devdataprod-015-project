
#This is done as part of preload to populate the drop down. 
# Load the data set of performance statistcs 
load("raw_stats.rda");

## convert ETL Project names something to meaningful.

raw_stats$Project <- gsub("DSS1", "BI - EDW", raw_stats$Project, perl=TRUE);
raw_stats$Project <- gsub("EDWToStores", "EDW To Stores", raw_stats$Project, perl=TRUE);
raw_stats$Project <- gsub("StoreHost", "Store Host Apps", raw_stats$Project, perl=TRUE);
raw_stats$Project <- gsub("customer", "BI - Customer", raw_stats$Project, perl=TRUE);

