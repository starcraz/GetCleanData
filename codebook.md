Codebook
========

Data Dictionary
--------------------------------------------------------------------------------

Variable name       | Description
--------------------|------------
subject             | ID of the experimental subjects of 30 volunteers
activity            | Activity field
featureDomain       | Feature data of time and frequency domain
featureInstrument   | Feature data by measuring with accelerometer or gyroscope instruments
featureAcceleration | Feature data of body acceleration
featureVariable     | Feature variable as mean and standard deviation
featureJerk         | Feature data of jerk signal
featureMagnitude    | Feature data of magnitude signals calculated using the Euclidean norm
featureAxis         | Feature data of 3-axial signals in X, Y and Z directions
featureCount        | Feature count of data points used to compute average
featureAverage      | Feature average of each variable for each activity and subject

Data structure
-----------------


```r
str(dtTidy)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  11 variables:
##  $ subject         : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity        : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ featureDomain      : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
##  $ featureAcceleration: Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
##  $ featureInstrument  : Factor w/ 2 levels "Accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ featureJerk        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 1 1 1 1 2 2 ...
##  $ featureMagnitude   : Factor w/ 2 levels NA,"Magnitude": 1 1 1 1 1 1 2 2 1 1 ...
##  $ featureVariable    : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 2 1 1 ...
##  $ featureAxis        : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
##  $ count           : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ average         : num  -0.0166 -0.0645 0.1487 -0.8735 -0.9511 ...
##  - attr(*, "sorted")= chr  "subject" "activity" "featureDomain" "featureAcceleration" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```


List of variables in the dataset
--------------------------------


```r
key(tidyData)
```

```
## [1] "subject"          "activity"         "featureDomain"      
## [4] "featureAcceleration" "featureInstrument"   "featureJerk"        
## [7] "featureMagnitude"    "featureVariable"     "featureAxis"
```


Example of dataset
------------------------------


```r
tidyData
```

```
##        subject         activity featureDomain featureAcceleration featureInstrument
##     1:       1           LAYING       Time               NA      Gyroscope
##     2:       1           LAYING       Time               NA      Gyroscope
##     3:       1           LAYING       Time               NA      Gyroscope
##     4:       1           LAYING       Time               NA      Gyroscope
##     5:       1           LAYING       Time               NA      Gyroscope
##    ---                                                                    
## 11876:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11877:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11878:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11879:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
## 11880:      30 WALKING_UPSTAIRS       Freq             Body  Accelerometer
##        featureJerk featureMagnitude featureVariable featureAxis count  average
##     1:       NA            NA         Mean        X    50 -0.01655
##     2:       NA            NA         Mean        Y    50 -0.06449
##     3:       NA            NA         Mean        Z    50  0.14869
##     4:       NA            NA           SD        X    50 -0.87354
##     5:       NA            NA           SD        Y    50 -0.95109
##    ---                                                            
## 11876:     Jerk            NA           SD        X    65 -0.56157
## 11877:     Jerk            NA           SD        Y    65 -0.61083
## 11878:     Jerk            NA           SD        Z    65 -0.78475
## 11879:     Jerk     Magnitude         Mean       NA    65 -0.54978
## 11880:     Jerk     Magnitude           SD       NA    65 -0.58088
```


Variable attributes
-------------------


```r
summary(tidyData)
```

```
##     subject                   activity    featDomain  featAcceleration
##  Min.   : 1.0   LAYING            :1980   Time:7200   NA     :4680    
##  1st Qu.: 8.0   SITTING           :1980   Freq:4680   Body   :5760    
##  Median :15.5   STANDING          :1980               Gravity:1440    
##  Mean   :15.5   WALKING           :1980                               
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                               
##  Max.   :30.0   WALKING_UPSTAIRS  :1980                               
##        featInstrument featJerk      featMagnitude  featVariable featAxis 
##  Accelerometer:7200   NA  :7200   NA       :8640   Mean:5940    NA:3240  
##  Gyroscope    :4680   Jerk:4680   Magnitude:3240   SD  :5940    X :2880  
##                                                                 Y :2880  
##                                                                 Z :2880  
##                                                                          
##                                                                          
##      count         average       
##  Min.   :36.0   Min.   :-0.9977  
##  1st Qu.:49.0   1st Qu.:-0.9621  
##  Median :54.5   Median :-0.4699  
##  Mean   :57.2   Mean   :-0.4844  
##  3rd Qu.:63.2   3rd Qu.:-0.0784  
##  Max.   :95.0   Max.   : 0.9745
```

Saving the tidy dataset
-----------------------

```r
tidy <- file.path(path, "SmartphoneTidyData.txt")
write.table(tidyData, tidy, quote = FALSE, sep = "\t", row.names = FALSE)
```
