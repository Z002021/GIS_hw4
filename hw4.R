library(sf)
library(tidyverse)
library(janitor)
library(readr)
library(here)
library(countrycode)

shape <- st_read(here("World_Countries_(Generalized)","World_Countries__Generalized_.shp"))

csv <-  read_csv("Gender Inequality Index (GII).csv", na = "..",skip = 5,
                 locale = locale(encoding = "latin1"))

# select and change country name to iso2
csv_diff <- csv%>%
  clean_names()%>%
  select(country,x2010,x2019)%>%
  mutate(diff_gender =x2010-x2019) %>%
  slice(1:189,)%>%
  mutate(iso_code=countrycode(country, origin='country.name',destination = 'iso2c'))

# join
joined_data <- shape %>% 
  clean_names() %>%
  left_join(., 
            csv_diff,
            by = c("aff_iso"= "iso_code"))