## Data sources

Public Health England (PHE) collects data on all SARS-CoV-2 (COVID-19) tests performed in NHS laboratories across England. Laboratory data systems provide an automatic daily feed of test results into PHE’s Second Generation Surveillance System (SGSS).

The NHS collects data on all hospital attendances and admissions. These data are collated by NHS Digital and sent daily to PHE via the Secondary Uses Service (SUS) and Emergency Care Dataset (ECDS) data collections. SUS data record admitted patient stays, ECDS records Accident and Emergency (A&E) attendances.


## Data preparation and linkage

Where a patient has multiple COVID-19 positive tests, the first positive test is retained.

Hospital records from SUS and ECDS are linked to SGSS using combinations of NHS number, hospital number and date of birth. The first positive COVID-19 test result is compared to the admission date from the hospital record.

Where a patient has had multiple hospital admissions, priority is given to:

1. tests taken during a hospital stay

2. hospital inpatient stays over A&E attendances

Where a test is taken between 2 distinct hospital admissions, the stay before the positive test result is used.

Patients counted as 'No record' in the most recent data may subsequently be counted as community-onset or healthcare-associated as records become available.


### Data changes

Due to variation in reporting on a hospital level, data is subject to change, particularly in the most recent six weeks. This may result in changes to both the provider where a case is reported against, and in the healthcare-associated infection category.


## Definitions of healthcare-associated COVID-19

+ If a patient has a first positive test within 2 days of being admitted, the infection is counted as ‘community-onset’ (CO). This is because the patient almost certainly became infected before being admitted to hospital.

+ If a patient has a first positive test 3-7 days after being admitted, the infection is counted as ‘hospital-onset, indeterminate healthcare-associated’ (HO.iHA). This is because we cannot be sure whether the infection occurred before or after the patient was admitted.

+ If a patient has a first positive test 8-14 days after being admitted, the infection is counted as ‘hospital-onset, probable healthcare-associated’ (HO.pHA). This is because the patient probably became infected whilst in hospital, but we cannot exclude the possibility that they were infected before being admitted to hospital.

+ If a patient has a first positive test 15 or more days after being admitted to hospital, the infection is counted as ‘hospital-onset, definite healthcare-associated’ (HO.HA). This is because the patient almost certainly became infected whilst in hospital. The source of infection may have been another patient, healthcare worker, visitor or other person with whom the patient had contact after being admitted to hospital.

+ Patients who do not have a record of hospital admission are counted as 'No hospital record' (NHR).

<a href="mailto:coronavirus-hcai@phe.gov.uk?subject=COVID HCAI Dashboard" target="_blank">Questions or feedback?</a>
