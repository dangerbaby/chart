=================================================================
INTRODUCTION
=================================================================

CHSv2_NACCS_Metadata.txt
last updated 30 March 2023

This file contains metadata for the Coastal Hazards System (CHS): 
North Atlantic Coast Comprehensive Study (NACCS). Much of the 
information provided below is available as attributes within each 
individual H5 data file.  However, if the H5 file is converted 
to .csv format, not all of the attributes are brought into the 
.csv file. This document means to provide a single location for 
all attributes for a specific study. 

 *  Please visit the CHS website https://chs.erdc.dren.mil/ for a
    detailed .pdf of the user guide, file formats and file naming
    convention.  Contact information for this file and CHS are 
    located at that website.

=========================================================
North Atlantic Coast Comprehensive Study (NACCS) Metadata
=========================================================

-------------------------------------
Storm Types
-------------------------------------
TS:  Tropical Synthetic
TH:  Tropical Historical (Validation)
XH:  ExtraTropical Historical
-------------------------------------

--------------------------------------------------------
Model Run Conditions
--------------------------------------------------------
SimB:           Base Conditions
SimB1RT:        Base Conditions, Random Tides
SimB1HT:        Base Conditions, Historical Tides
SimB1RTgslc1p0: Base Conditions, Random Tides, 
                Sea Level Change of 1 m
SimB1HTgslc1p0: Base Conditions, Historical Tides, 
                Sea Level Change of 1 m
--------------------------------------------------------

-----------------------------------
Vertical Datum:    MSL (epoch 1992)
-----------------------------------

----------------------------------------------------
Steric Adjustments: Tropical Synthetic (TS) Storms
----------------------------------------------------
Value:        0.109 m (for each TS storm)
 
Description:  Baroclinic steric height adjustment; 
              Weighted average (based on # of storms
              per month) of the seasonal adjustment 
              values from NOAA gauges
----------------------------------------------------

----------------------------------------------------
Steric Adjustments: Tropical Historical (TH) Storms
----------------------------------------------------
ID    NAME      Year     Value
--    ----      ----     -----
001  Sandy      2012     0.155 m
002  Irene      2011     0.111 m
003  Isabel     2003     0.042 m
004  Josephine  1984     0.147 m
005  Gloria     1985    -0.081 m
  
Description:  Baroclinic steric height adjustment; 
              Mean water level during month of the 
              event based on values from NOAA gauges
----------------------------------------------------

--------------------------------------------------------
Steric Adjustments: ExtraTropical Historical (XH) Storms
--------------------------------------------------------
ID     NAME           Value
--     ----           -----
 1     1938012513     0.096
 2     1940021503     0.105
 4     1943102703     0.159
 5     1945113009     0.105
 6     1947030306     0.114
 7     1950112521     0.105
 8     1952031118     0.129
10     1952112122     0.132
11     1953110710     0.159
12     1958021620     0.105
13     1960021907     0.105
14     1960030415     0.114
15     1961020410     0.096
16     1961041400     0.153
17     1962030706     0.114
18     1962120616     0.105
19     1964011318     0.090
20     1966012310     0.096
21     1966013016     0.096
22     1968111212     0.132
23     1970121714     0.095
24     1971030416     0.114
25     1971112511     0.105
26     1972020406     0.096
27     1972021912     0.105
28     1972110902     0.132
29     1972121606     0.095
30     1973012914     0.096
31     1974120209     0.105
32     1976020210     0.096
33     1977011019     0.090
34     1977101419     0.182
35     1978012020     0.090
36     1978012618     0.096
37     1978020701     0.096
38     1978042623     0.163
39     1978122516     0.085
40     1979012123     0.096
41     1980102521     0.159
42     1982102510     0.159
43     1983021118     0.105
44     1983031906     0.129
45     1983112523     0.105
46     1983121221     0.095
47     1983122302     0.085
48     1983122903     0.085
49     1984022905     0.114
50     1984032921     0.143
51     1985021301     0.105
52     1985110507     0.159
53     1987010207     0.085
54     1987012306     0.096
55     1988041317     0.153
56     1988110212     0.159
57     1990111104     0.132
58     1991103020     0.159
59     1992010416     0.085
60     1992121122     0.095
61     1993030501     0.114
62     1993031400     0.129
63     1993112815     0.105
64     1993122122     0.095
65     1994010413     0.085
66     1994030223     0.114
67     1994122412     0.085
68     1995020500     0.096
69     1995111503     0.132
70     1996010806     0.200
72     1996102002     0.182
73     1996120811     0.118
74     1997011009     0.090
75     1997041912     0.153
76     1998012821     0.096
77     1998020501     0.096
78     2000012512     0.096
79     2001030710     0.114
80     2003121805     0.095
81     2003121805     0.095
82     2006100706     0.204
83     2006102819     0.159
84     2006111701     0.132
85     2006112217     0.132
86     2007041605     0.153
87     2008051204     0.167
88     2008122205     0.095
89     2009111302     0.132
90     2009120922     0.095
91     2009121918     0.095
92     2009122610     0.085
93     2010022604     0.114
94     2010031307     0.129
95     2010100104     0.204
96     2010101513     0.182
97     2010122706     0.085
98     2011041703     0.153
99     2012122112     0.095
100    2012122707     0.085
101    2010020609     0.096
102    2000121721     0.101
103    2003101516     0.175
 
Description:  Baroclinic steric height adjustment; 
              Mean water level during month of the 
              event based on values from NOAA gauges
----------------------------------------------------

------------------------------------------------------------------
STWAVE Grid Description
------------------------------------------------------------------
Cartesian grid in a local coordinate system, with the x-axis
oriented in the cross-shore direction and y-axis oriented
alongshore. 
------------------------------------------------------------------

------------------------------------------------------------------
STWAVE Output - Direction Convention
------------------------------------------------------------------
Wave and wind directions are relative to the STWAVE coordinate
system and are measured counterclockwise from the x-axis. To
post-process these raw output values, take the STWAVE grid's
Azimuth (specified in the table below) and add that to the wave/
wind direction value. If the result is greater than 360 degrees,
a modulo can be performed on it to get it back into the 0 to 360
range (e.g. 450 degrees would be set to 90 degrees). The resulting
angle is in Cartesian coordinates, with 0 being east, 90 north,
180 west and 270 south, and it represents the wave/wind heading
toward that degree direction.
------------------------------------------------------------------

------------------------------------------------------------------
STWAVE Grid Parameters
------------------------------------------------------------------
ID    NAME   State Plane Zone   Azimuth
--    ----   ----------------   -------
01    CME          19           112.00000
02    CNJ          18           153.10000
03    CPB          18           159.80000
04    EMA          19           180.00000
05    LID          18           117.90000
06    NME          19           110.70000
07    NNJ          18           150.20000
08    SMA          19           101.90000
09    SME          19           133.00000
10    WDC          18           159.90000

Azimuth Description: value = the azimuth (rotation) of the grid 
in degrees, measured counterclockwise from East
------------------------------------------------------------------

-------------------------------
ADCIRC Record Interval:  10 min 
-------------------------------


==================================================================
Statistics
==================================================================

-----------------
AEP (H5 Files)
-----------------
------------------------------------------------------------------
WL
------------------------------------------------------------------
Parameter:   Water Level
SimB:        Base Simulation no Tide
CC:          Combined Cyclone
Post0:       No Post Processing
AEP:         Annual Exceedance Probability; Marginal Storm Surge
             Level (SSL) AEP includes storm surge and wave setup.
------------------------------------------------------------------

------------------------------------------------------------------
Hs
------------------------------------------------------------------
Parameter:   Significant Wave Height
SimB1RT:     Base Simulation plus 1 Random Tide
CC:          Combined Cyclone
Post0:       No Post Processing
AEP:         Annual Exceedance Probability; Marginal Significant Wave 
             Height (Hs) refers to the Hs AEP without reference  
             to SWL AEP. Does not account for the correlation  
             between Hs and SWL.
------------------------------------------------------------------

------------------------------------------------------------------
WL
------------------------------------------------------------------
Parameter:   Water Level
SimB:        Base Simulation
CC:          Combined Cyclone
Post96RT:    Post Processing with 96 Random Tides
AEP:         Annual Exceedance Probability; Marginal Still Water
             Level (SWL) AEP includes storm surge, astronomical
             tide, and wave setup. 
------------------------------------------------------------------

==================================================================
Peaks Files - Time Description
==================================================================
------------------------------------------------------------------
ADCIRC 

yyyymmddHHMM:    Time of the Peak Water Elevation

Note that the values for Atmospheric Pressure, Depth Averaged 
Velocity, and Wind Velocity are correlated in time with the
maximum Water Elevation and represent the value that occurred at
the time of the peak Water Elevation for that dataset during the
timeseries of the storm. 

------------------------------------------------------------------
STWAVE 

yyyymmddHHMM:    Time of the Peak Significant Wave Height

Note that the values for Mean Wave Direction, Mean Wave Period, 
Peak Period, Water Elevation, Wind Direction, and Wind 
Magnitude are correlated in time with the maximum Significant 
Wave Height (Hm0) and represent the value that occurred at the 
time of the peak Hm0 for that dataset during the timeseries 
of the storm. 
------------------------------------------------------------------
