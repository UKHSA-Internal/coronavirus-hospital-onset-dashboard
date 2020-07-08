# Methods

## Data sources

Public Health England (PHE) collects data on all SARS-CoV-2 COVID-19 PCR tests taken in hospital laboratories across England. Laboratory data systems automatically feed into PHE’s Second Generation Surveillance System (SGSS) daily.  A weekly extract of all Pillar 1 cases, those with medical need and critical key workers, is taken.

The National Health Service (NHS) collect data on all hospital attendances and admissions for payment by results. These data are collated by NHS Digital and sent daily to PHE via the Secondary uses Service (SUS) and Emergency Care Dataset (ECDS) data collections, on admitted patient stays, and Accident and Emergency (A&E) attendances, respectively.

## Data preparation and linkage

Where a patient has multiple COVID-19 positive tests, the first positive test is retained. 

Hospital records from SUS and ECDS are linked to SGSS using combinations of NHS number, hospital number and date of birth. The first positive COVID-19 test result is compared to the admission date from the hospital record.

Where a patient has had multiple hospital admissions, priority is given to: (1) tests taken during a hospital stay; (2) hospital inpatient stays over A&E attendances. Where a test is taken between two distinct hospital admissions, the stay prior to the positive test result is used. 

## HCAI Categories

Cases are presented in Healthcare associated infection (HCAI) categories. Allocation to a HCAI category is calculated using the first positive COVID19 PCR test result per patient, paired with the date of admission for an inpatient hospital stay or an emergency care A&E attendance.

Records are not allocated to an HCAI category where COVID19 positive tests have not linked to a hospital admission. In these unlinked cases, hospital provider sites are determined based on the reporting laboratory. Unlinked cases may be related to healthcare staff, outpatient or nursing home patients tested within the NHS or PHE laboratories who do not have a record on ECDS or SUS.
| HCAI Category                                                | Criteria                                                                                                                                                                                  |
|--------------------|-------------------------------------------------------------------------------------------------|
| Community-Onset (CO)                                         | Positive specimen date <=2 days after hospital admission  <br>or  <br>hospital attendance ±14 days from a positive specimen date with no test during a confirmed hospital admission <br>  |
| Hospital-Onset Indeterminate Healthcare-Associated (HO.iHA)  | Positive specimen date 3-7 days after hospital admission                                                                                                                                  |
| Hospital-Onset Probable Healthcare-Associated (HO.pHA)       | Positive specimen date 8-14 days after hospital admission                                                                                                                                 |
| Hospital-Onset Definite Healthcare-Associated (HO.dHA)       | Positive specimen date 15 or more days after hospital admission                                                                                                                           |
| Unlinked COVID-19 Positive Specimen                          | No link was made between the positive test and a hospital stay; HCAI category cannot be established                                                                                       |

[Questions or feedback?](mailto:coronavirus-hcai@phe.gov.uk?subject=COVID%20%HCAI%20%Dashboard)
