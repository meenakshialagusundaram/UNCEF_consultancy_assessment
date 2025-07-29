********************************************************************************
* UNICEF Consultancy Assessment
* Purpose of Do File: User Profile Set Up
* Created by: Meenakshi Alagusundaram
* Created on: July 27, 2025
* Modified by: 
* Modified on:
********************************************************************************

clear all 
set more off

// Set the root directory to the folder containing this file here

global wd : pwd

// Define the paths to sub-folders 

global raw      "$wd/01_rawdata"
global cleaned  "$wd/02_cleandata"
global dofiles  "$wd/03_dofiles"
global output   "$wd/04_output"

