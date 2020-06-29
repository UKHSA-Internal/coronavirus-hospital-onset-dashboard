### Methods

#### Data sources

Public Health England (PHE) collects data on all SARS-CoV-2 COVID-19 PCR tests taken in hospital laboratories across England. Laboratory data systems automatically feed into PHE’s Second Generation Surveillance System (SGSS) daily.  A weekly extract of all Pillar 1 cases, those with medical need and critical key workers, is taken.

The National Health Service (NHS) collect data on all hospital attendances and admissions for payment by results. These data are collated by NHS Digital and sent daily to PHE via the Secondary uses Service (SUS) and Emergency Care Dataset (ECDS) data collections, on admitted patient stays, and Accident and Emergency (A&E) attendances, respectively.

Data was extracted from all sources on `r file.info("./hcai.csv")$mtime`.

#### Data preparation and linkage

Where a patient has multiple COVID-19 positive tests, the first positive test is retained. SUS data is presented in consultant episodes, where a patient in under the continuous care of a single consultant. Episodes are grouped into spells, a continuous inpatient stay within a single hospital provider. Length of stay is calculated by comparing admission and discharge dates of a hospital spell.

Hospital records from SUS and ECDS are linked on NHS number, hospital number and date of birth where the A&E departure date matches an inpatient admission date within the same healthcare provider. These combined hospital records are linked to SGSS COVID-19 positive tests on either NHS number or hospital number and date of birth where the positive test was taken during a hospital admission or within 14 days prior to a hospital admission.

Where a patient has had multiple hospital admissions, priority is given to: (1) tests taken during a hospital stay; (2) hospital inpatient stays over A&E attendances. Where a test is taken between two distinct hospital admissions, the stay prior to the positive test result is used.

#### HCAI Categories

Cases are presented in Healthcare associated infection (HCAI) categories (Table 2). Allocation to a HCAI category is calculated using the first positive COVID19 PCR test result per patient, paired with the date of admission for an inpatient hospital stay or an emergency care A&E attendance.
Records are not allocated to an HCAI category where COVID19 positive tests have not linked to a hospital admission. In these unlinked cases, hospital provider sites are determined based on the reporting laboratory. Unlinked cases may be related to healthcare staff, outpatient or nursing home patients tested within the NHS or PHE laboratories who do not have a record on ECDS or SUS.


Questions: [Alex Bhattacharya](mailto:alex.bhattacharya@phe.gov.uk?subject=COVID%20%HCAI%20%Dashboard)
