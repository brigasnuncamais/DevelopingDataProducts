---
title       : French TER (regional train) monthly regularity
subtitle    : since January 2013
author      : brigasnuncamais
job         : Business Intelligence / Data Scientist consultant
framework   : impressjs     # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides

--- .slide x:-1000 y:-1500

<a href="http://data.sncf.com/" target="_blank">
<img src="http://www.sncf.com/theme/images/logo-sncf.png" alt="SNCF Open Data" title="SNCF Open Data"></a>
<q>French **TER** (regional train) Monthly Regularity<br>Since January 2013</q><br/>
<br/>
<br/>
<br/>
<a href="http://brigasnuncamais.shinyapps.io/DevelopingDataProducts/" target="_blank">My shinyapp</a> | <a href="https://ressources.data.sncf.com/explore/dataset/regularite-mensuelle-ter/download/?format=csv&timezone=Europe/Berlin&use_labels_for_header=true" target="_blank">TER data</a> 

--- #title x:0 y:0 scale:2

<span class="try"><a href="https://www.jhu.edu" target="_blank">Developing Data Products</a>^* Course Project</span>  
 <br/>
 <br/>
 Pierre Vettori - brigasnuncamais  <br/>
Sun May 24th, 2015  <br/>
 <br/>
 ^* a Johns Hopkins Bloomberg school of public health Mooc

--- x:1000 y:-1500

<div id="bg">
  <img src="assets/img/SS850452.png" alt="">
</div>

<q>Do you think it is the Wild Wild West?</q>  
   <br/>
   <br/>
No, it's Tarare, my home town.    
Lyon is 40mins from here by the TER.   
Now I can hear the train coming.  

--- #its x:3000 y:4000 rot:45 scale:5

<div id="bg">
  <img src="assets/img/SS850457.png" alt="">
</div>

-- **SNCF**, the french railway operator <br/>
  <br/>
 gave the access to some data about schedules, late or deleted trains. <br/>
-- I built an application to statistically manipulate this data: <br/>
  540 records concerning aggregated count of trains in all Administrative French regions.

--- #big x:4000 y:1000 rot:180 scale:2

not <b>big data</b> <span class="thoughts">but...</span>

--- #tiny x:2825 y:2325 z:-3000 rot:300 scale:2


```r
# Plot NumberOfScheduledTrains vs NumberOfLateTrainsOnArrival; facet and
# color by year
ggplot(dataset, aes_string("NumberOfScheduledTrains", "NumberOfLateTrainsOnArrival")) + 
    geom_point() + theme(axis.text.x = element_text(angle = 45, hjust = 1, colour = "black")) + 
    aes_string(color = "Year") + facet_grid(".~Year") + geom_smooth(group = "NumberOfScheduledTrains")
```

![plot of chunk unnamed-chunk-1](assets/fig/unnamed-chunk-1-1.png) 

---
