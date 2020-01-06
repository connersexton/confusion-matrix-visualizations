#######
## Data Management
## Conner Sexton
## January 5, 2020
#######
library(dplyr)

## Import Kaggle Dataset:

df <- read.csv("raw_data/political_social_media.csv", stringsAsFactors=FALSE, fileEncoding="latin1")
# encoding with latin1 was necessary as some of the text clean up functions won't work otherwise.

## Clean Variable Names:
df %>%
  rename(unit_id = X_unit_id,
         golden = X_golden,
         unit_state = X_unit_state,
         trusted_judgements = X_trusted_judgments,
         last_judgement_at = X_last_judgment_at,
         orig_golden = orig__golden) -> df

## Deal with missing columns/data:
k = which(colSums(is.na(df))>0) # select columns where the sum of missing values is greater than 0.
df <- df[, -k]


## Add Politician Attributes:
## source: GitHub @unitedstates

vars = c("full_name", "gender", "party", "bioguide_id", "birthday")
leg_historical <- read.csv("raw_data/legislators-historical.csv", na.strings = "")[,vars]
leg_current <- read.csv("raw_data/legislators-current.csv", na.strings = "")[,vars]
legislators <- rbind(leg_historical, leg_current)

# join attributes with Kaggle dataset:
df %>%
  left_join(legislators, by = c("bioid" = "bioguide_id")) -> temp_full

## Select Variables:
temp_full %>%
  select(text, gender, party) -> project_data


## Export Data:
save(project_data, file = "project_data.RData")
write.csv(project_data, file = "project_data.csv")
