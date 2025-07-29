# UNICEF Education D&A Consultancy Test
Assessment for UNICEF Consultancy Position

## Repository Structure

- `01_rawdata/`: Contains input datasets provided (WPP data, U5MR classification, UNICEF indicators)
- `02_cleandata/`: Processed and cleaned data files used for analysis
- `03_dofiles/`: 
  - `user_profile.do`: Sets up directory structure for portability
  - `run_project.do`: Executes the full workflow and generates the final output
- `04_output/`: Final report and visualizations

## Objective

Calculate population-weighted coverage of two maternal health indicators:
- ANC4: % of women aged 15–49 with at least 4 antenatal visits
- SBA: % of deliveries attended by skilled health personnel

which are categorized by countries **on-track** or **off-track** in achieving under-five mortality goals.

## Reproducibility

### To run the full project:

1. Open Stata
2. Run `03_dofiles/run_project.do`

Ensure the working directory is set correctly by modifying `user_profile.do` according to your own machine.

## Anonymity

This repository is anonymized per instructions.

## Position applied for

Position: **Learning and Skills Data Analyst Consultant – Req. #581598**
