## create trust name and type lookup
## export for dashboard lookup

## Independent Sector Trusts
loc.url <- "https://nhsenglandfilestore.s3.amazonaws.com/ods/ephp.zip"
td <- tempdir()
tf <- tempfile(tmpdir=td, fileext=".zip")
download.file(loc.url, tf)
fname <- unzip(tf, list=TRUE)$Name[1]
unzip(tf, files=fname, exdir=td,overwrite=TRUE)
fpath <- file.path(td, fname)
independent_sector <-
  readxl::read_xls(fpath,
                   sheet = 1,
                   col_names = c("trust_code",
                                 "trust_name",
                                 paste0("x", 1:20))) %>%
  select(trust_code,trust_name,postcode=x8)

nhs_ind <-  rgisws::postcode_lookup(independent_sector$postcode,col_names = "nhser") %>%
  select(input_pcd,nhser) %>%
  mutate(nhs_region=case_when(
    nhser=="E40000003" ~ "LONDON",
    nhser=="E40000005" ~ "SOUTH EAST",
    nhser=="E40000006" ~ "SOUTH WEST",
    nhser=="E40000007" ~ "EAST OF ENGLAND",
    nhser=="E40000008" ~ "MIDLANDS",
    nhser=="E40000009" ~ "NORTH EAST AND YORKSHIRE",
    nhser=="E40000010" ~ "NORTH WEST"
    ))

independent_sector <- left_join(independent_sector,nhs_ind,by=c("postcode"="input_pcd")) %>%
  select(-poscode,nhser)

## ERIC gives Trust Type lookup
eric <- read_csv("./lookup/ERIC - 201819 - TrustData v4.csv") %>%
  select(trust_code=`Trust Code`,
         trust_name=`Trust Name`,
         trust_type=`Trust Type`,
         nhs_region=`New Commissioning Region`) %>%
  mutate(nhs_region=gsub(" COMMISSIONING REGION","",nhs_region))

trust_names <- bind_rows(independent_sector,eric) %>%
  mutate(trust_type=ifelse(is.na(trust_type),"INDEPENDENT SECTOR",trust_type)) %>%
  mutate(trust_type=ifelse(grepl("ACUTE",trust_type),"ACUTE",trust_type))

manual <- data.frame(
  trust_code=c("R0B","DJN"),
  trust_name=c("SOUTH TYNESIDE AND SUNDERLAND NHS FOUNDATION TRUST",
               "INTEGRAL MEDICAL HOLDINGS"),
  nhs_region=c("NORTH EAST AND YORKSHIRE","NORTH WEST"),
  trust_type=c("ACUTE","INDEPENDENT SECTOR")
  )

trust_names <- bind_rows(trust_names,manual)

write.csv(trust_names,"./lookup/trust_names.csv",row.names = F)

## ORG CHANGES
## org_change_reason: F=code change, O=type change, R=reconfig (merger/split)
## org_change_indicator: NA=no further change, F=further change, X = closed
loc.url <- "https://files.digital.nhs.uk/assets/ods/current/succarc.zip"
td <- tempdir()
tf <- tempfile(tmpdir=td, fileext=".zip")
download.file(loc.url, tf)
fname <- unzip(tf, list=TRUE)$Name[1]
unzip(tf, files=fname, exdir=td,overwrite=TRUE)
fpath <- file.path(td, fname)
org_changes <- readr::read_csv(
  fpath,
  col_names = c(
    "org_code",
    "new_org_code",
    "org_change_reason",
    "org_change_date",
    "org_change_indicator"
  )
)

