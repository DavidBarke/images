library(readxl)
library(dplyr)

source("./data/process_catalog_helpers.R")

# Import ----
src_tbl <- read_excel("./data/catalog.xlsx")

# Transform ----
names(src_tbl) <- tolower(names(src_tbl))

src_tbl <- src_tbl %>% filter(form == "painting")

name_tbl <- extract_name(src_tbl$author)

life_tbl <- extract_life(src_tbl$`born-died`)

url_tbl <- extract_url(src_tbl$url)

tbl <- bind_cols(
  src_tbl,
  name_tbl,
  life_tbl,
  url_tbl
) %>%
  select(-author, -`born-died`) %>%
  filter(form == "painting")