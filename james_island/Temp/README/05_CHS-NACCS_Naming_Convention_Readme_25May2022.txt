INTRODUCTION
===========

05_CHS_NACCS_Naming_Convention_Readme_25May2022.txt
last updated 25 May 2022

This file contains the Coastal Hazards System (CHS) Filename 
Convention for the CHS North Atlantic Coast Comprehensive Study
(CHS-NACCS) dataset which includes the coastal areas from
Virginia to Maine.  

 *  For detailed information, please see the CHS website 
    https://chs.erdc.dren.mil/. 
    Contact information is also located at that website.


FILENAMING CONVENTION FORMAT
===========================

The CHS filename convention has a standard set of unique
identifiers which make up the filenames for the data
files posted in the system. These identifiers allow each filename
to be self-describing. Detailed information for each identifier
for all CHS-NACCS data files is provided below. 

All filenames have 
 *   7 identifiers separated by underscores 
 *   followed by an extension for the filetype
 *   In this format:

Identifier1_Identifier2_Identifier3_Identifier4_Identifier5
			              _Identifier6_Identifier7.ext 


IDENTIFIER DESCRIPTIONS
=======================

Each identifier is described in the following format
* Identifier#
* Data Names separated by ||
* Data Description
* Example
   -  the identifier being demonstrated is indicated by triangle 
      brackets, for example <SP001>
* Table of Identifier format code and description



Identifier1
-----------
 *   Identifier1 = Project || Region || Sub-region
 *   Identifier1 consists of a string specifying project name, 
     region name or sub-region name, depending on the data
     structure

 *   Example: <CHS-NA>_TS_SimB_Post0_SP0002_STWAVE03_Peaks.h5
     --  where <CHS-NA> in Identifier1 indicates the NACCS study

Table 1: Identifier1; CHS-NACCS data type identifiers with a 
         description
=================================================================
| Format     | Description                                      |
=================================================================
| CHS-NA     | CHS - NACCS from Virginia to Maine               |
=================================================================



Identifier2
-----------
 *   Identifier2 = Storm Type || Data Type
 *   Identifier2 consists of a string specifying either the storm 
     type or the data type

 *   Example: CHS-NA_<TS>_SimB_Post0_SP0002_STWAVE03_Peaks.h5
     --  where <TS> in Identifier2 indicates model results for 
         Tropical Synthetic storm type

Table 2: Identifier2; CHS-NACCS storm type identifiers with a 
         description of each
=================================================================
| Format | Description                                          |
=================================================================
| TS     | Model results for Tropical Synthetic storm type      |
-----------------------------------------------------------------
| XH     | Model results for Extratropical Historical storm type|
-----------------------------------------------------------------
| CC     | Statistics for Combined (Tropical Extratropical/     |
|        | Historical Synthetic) storm type                     |
-----------------------------------------------------------------
| Val    | Model results for Validations                        |
=================================================================


Identifier3
-----------
 *   Identifier3 = Simulation
 *   Identifier3 consists of a string that defines the simulation 
     parameters for a specific project
    
 *   Example:  CHS-NA_TS_<SimB>_Post0_SP0002_STWAVE03_Peaks.h5
     --  where <SimB> in Identifier3 indicates Base Conditions; 
         No tides; No sea level change

Table 3: Identifier3; CHS-NACCS simulation identifiers with a 
         description of each
=================================================================
| Format         | Description                                  |
=================================================================
| Sim0           | No simulation (storm files, some statistical |
|                | files)                                       |
-----------------------------------------------------------------
| SimB           | Base Conditions; No tides;                   |
|                | No sea level change                          |
-----------------------------------------------------------------
| SimB1RT        | Base plus 1 random tide; No sea level change |
|                | (Tropical Synthetic (TS) Storms only)        |
-----------------------------------------------------------------
| SimB1HT        | Base plus 1 historical tide;                 |
|                | No sea level change                          |
|                | (Extratropical Historical (XH) Storms only)  |
-----------------------------------------------------------------
| SimB1RTgslc1p0 | Base plus 1 random tide plus global sea level|
|                | change 1.0 m (TS Storms only)                |
-----------------------------------------------------------------
| SimB1HTgslc1p0 | Base plus 1 historical tide plus global sea  |
|                | level change 1.0 m (XH Storms only)          |
=================================================================



Identifier4 
-----------
 *   Identifier4 = Post-processing
 *   Identifier4 consists of a string specifying the types of 
     post-processing performed. Note that these may be 
     project-specific

 *   Example:  CHS-NA_TS_SimB_<Post0>_SP0002_STWAVE03_Peaks.h5
     --  where <Post0> in Identifier4 indicate No Post Processing 

Table 4: Identifier4; CHS-NACCS post-processing identifiers with
         a description of each
=================================================================
| Format     | Description                                      |
=================================================================
| Post0      | No Post Processing                               |
-----------------------------------------------------------------
| Post1RT    | 1 random tide (statistics files)                 |
-----------------------------------------------------------------
| Post96RT   | 96 random tides                                  |
=================================================================



Identifier5
-----------
 *   Identifier5 = Save Point || Statistics || Storm
 *   Identifier5 consists of a string specifying either the save 
     point ID, the storm ID, the observation station ID, or the
     data type.

 *   Example:  CHS-NA_TS_SimB_Post0_<SP0002>_STWAVE03_Peaks.h5
     --  where <SP002> indicates Save Point 002

Table 5: Identifier5; CHS-NACCS identifier5 format identifiers
         with a description of each 
=================================================================
| Format  | Description                                         |
=================================================================
| SP#     | SP followed by a save point ID                      |
-----------------------------------------------------------------
| Stat    | Statistics file for ALL savepoints (NLR file)       |
-----------------------------------------------------------------
| ST      | All storms for specified project (applies to storm  |
|         | data)                                               |
=================================================================



Identifier6
-----------
 *   Identifier6 = Model
 *   Identifier6 consists of a string specifying the model name,
     and grid number where applicable, for model results. This 
     identifier is also used to specify the statistics parameter
     for statistics files, the type of model input or output
     file, the source for storm tracks and characteristics, or
     the source of observations data.

 *   Example:  CHS-NA_TS_SimB_Post0_SP0002_<STWAVE03>_Peaks.h5
     --  where <STWAVE03> in Identifier6 indicates the STWAVE
         model with grid 3

Table 6: Identifier6; CHS-NACCS identifier6 format file 
         identifiers with a description of each
=================================================================
| Format     | Description                                      |
=================================================================
| ADCIRC#    | ADCIRC model followed by grid ID (grid ID 01 is  |
|            | default)                                         |
-----------------------------------------------------------------
| STWAVE#    | STWAVE model followed by the grid ID             |
-----------------------------------------------------------------
| TROP       | Track and storm characteristics description file |
-----------------------------------------------------------------
| HURDAT     | Track and storm characteristics description file |
|            | from the HURricane DATabase                      |
-----------------------------------------------------------------
| WL         | Water Level (Model parameter specific to         |
|            | statistics files)                                |
-----------------------------------------------------------------
| Hs         | Wave Height (Model parameter specific to         |
|            | statistics files)                                |
-----------------------------------------------------------------
| Tp         | Wave Period (Model parameter specific to         |
|            | statistics                                       |
|            | files)                                           |
-----------------------------------------------------------------
| TROP       | Track and storm characteristics description file |
-----------------------------------------------------------------
| Stat       | File contains statistics data                    |
-----------------------------------------------------------------
| WaterLevel | NLR Statistics File                              |
=================================================================



Identifier7
-----------
 *   Identifier7 = Result Type || Input Type
 *   Identifier7 consists of a string specifying the type of data 
     contained within the file.
     
 *   Example:  CHS-NA_TS_SimB_Post0_SP0002_STWAVE03_<Peaks>.h5
     --  where <Peaks> in Identifier7 indicates Peak results

Table 7: Identifier7; CHS-NACCS results or statistics file 
         identifiers with a description of each
=================================================================
| Format     | Description                                      |
=================================================================
| TimeSeries | Model results and observations                   |
-----------------------------------------------------------------
| Peaks      | Model results and observations                   |
-----------------------------------------------------------------
| AEP        | Annual Exceedance Probability (statistics files) |
-----------------------------------------------------------------
| SRR        | Storm Recurrence Rate (statistics files)         |
-----------------------------------------------------------------
| STcond     | Storm Conditions                                 |
-----------------------------------------------------------------
| NLR        | Nonlinear Residual                               |
-----------------------------------------------------------------
| Param      | Storm Parameters (synthetic storms)              |
-----------------------------------------------------------------
| ProbMass   | Probability Mass (synthetic storms)              |
=================================================================



Extension
-----------
 *   filename extension

Table 8: Extensions
=================================================================
| Format     | Description                                      |
=================================================================
| .h5        |  HDF5 data model, library and file format for    |
|            |  storing and managing data                       |
-----------------------------------------------------------------
| .csv       | Comma Separated Values                           |
=================================================================


End File