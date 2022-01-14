# LTERbuoys
R code to import and format NTL LTER buoy data
Functions to clean and format remote buoy data to export to single CSV

#update 1/14/2022
added QC in funtions
  -rbr_temp -checks for temps above below 0 and above 30
            -compares mean of surface to bottom to make sure order is correct
            
  -pme_do -checks for values below 0 and above 15 mg/l
           -checks Q value for sample quality currently have checks at 0.75, 0.9 and 1.15 (these values should be double checked)
           
  -hobo_light -checks for duplicate dates after rounding
  
