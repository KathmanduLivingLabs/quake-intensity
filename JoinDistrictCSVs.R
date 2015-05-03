library(plyr)
library(dplyr)
library(reshape2)
library(stringr)

#### YOU WILL NEED TO CHANGE THIS DIRECTORY:
setwd("~/Code/KLL/quake-intensity/")

to_long <- function(district_csv) {
    cat(district_csv)
    dist <- read.csv(str_c("vdc_data/", district_csv))
    dist <- dist %>% 
        subset(!is.na(VCODE)) %>% 
        select(-Total.VDC.Munci)
    dist <- na.exclude(melt(dist, id.vars=c("X", "VCODE", "HH", "Pop")))
    dist <- dist %>% 
        mutate(Intensity = str_extract(variable, '[0-9]$')) %>%
        select(-variable, -value)
    dist
}

csvs <- list.files("vdc_data/")
all_dists <- llply(csvs, to_long)
write.csv(rbind_all(all_dists), "All_District_Intensity.csv")
