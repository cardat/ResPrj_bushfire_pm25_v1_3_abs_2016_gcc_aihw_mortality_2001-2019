---
title: "Increased risks of mortality in the 21st century (2001-2020) attributable
  to PM₂.₅ in Australian Great Capital Cities"
output:
  html_document:
    keep_md: true
    fig_path: "report/"
    md_document:
      variant: markdown_strict
      path: "report/"
---
Lucas Hertzog<sup>1,2</sup>, Edward Jegasothy<sup>3</sup>, Karthik Gopi<sup>3,4</sup>, Cassandra Yuen<sup>1,3</sup>, Dana Jordan<sup>3</sup>, Geoffrey Morgan<sup>3,4</sup>, Ivan Hanigan<sup>1,2</sup>

1. School of Population Health, Faculty of Health Sciences, Curtin University, WA 6102, Australia
2. WHO Collaborating Centre for Climate Change and Health Impact Assessment, WA 6102, Australia
3. School of Public Health, Faculty of Medicine and Health, University of Sydney, Camperdown, NSW 2006, Australia 
4. University Centre for Rural Health, Faculty of Medicine and Health, University of Sydney, Lismore, NSW 2480, Australia

## Study area
<img src="figures_and_tables/fig_study_area.png" width="3507" />

## Outcome
### Average Daily Mortality 2001-2020 (AIHW all causes and ages)

<img src="figures_and_tables/fig_mortality.png" width="2160" />


Table: Summary of study cities and number of deaths from 2001 to 2020

|City      |Deaths  |
|:---------|:-------|
|Sydney    |618,067 |
|Melbourne |557,186 |
|Brisbane  |278,566 |
|Adelaide  |216,568 |
|Perth     |230,698 |
|Hobart    |41,271  |
|Darwin    |11,261  |
|Canberra  |39,012  |

## Exposure

Table: Summary  in number of days per air quality level. The ratio represents the sum of all days with PM₂.₅ (µg/m³) levels not considered good by WHO divided by days considered good. GCCs are ranked from best to worst ratio.

|City      | good| moderate| unhealthy_sensitive| unhealthy| very_unhealthy| hazardous| extreme|      Ratio|
|:---------|----:|--------:|-------------------:|---------:|--------------:|---------:|-------:|----------:|
|Hobart    | 5483|     1800|                  11|        10|              1|         0|       0|  0.3322998|
|Darwin    | 2431|     3296|                1503|        75|              0|         0|       0|  2.0049362|
|Canberra  | 2398|     4708|                 115|        27|             40|        13|       4|  2.0462886|
|Brisbane  | 2079|     5138|                  65|        19|              3|         1|       0|  2.5137085|
|Melbourne | 1892|     5279|                 100|        24|              9|         1|       0|  2.8609937|
|Sydney    | 1213|     5911|                 123|        46|             11|         1|       0|  5.0222589|
|Adelaide  |  612|     6662|                  26|         5|              0|         0|       0| 10.9362745|
|Perth     |  150|     7071|                  77|         7|              0|         0|       0| 47.7000000|

### PM₂.₅ (µg/m³) time-series 2001-2020
<img src="figures_and_tables/fig_exposure_time_series.png" width="3840" />

## Methods
PM₂.₅ Predicted = Daily PM2.5 predictions from the random forest model (Bushfire_specific_PM25_Aus_2001_2020_v1_3).

The STL method is used to decompose the time-series into three components: trend, seasonal, and remainder.

The counterfactual is calculated as the sum of the seasonal and trend components, i.e., Counterfactual = Seasonal + Trend.

Following the HRAPIE project's recommendations for concentration–response functions for cost–benefit analysis of particulate matter, the estimated Relative Risk (RR) per 10 μg/m³ increase in PM₂.₅ is 1.0123, with a 95% Confidence Interval (CI) of 1.0045 to 1.0201:

$$
RR_{10\, \mu g/m^3} = 1.0123 \, (95\% \, CI: 1.0045 - 1.0201)
$$
Then, we calculate beta:

$$
\beta = \frac{\log(RR_{10\, \mu g/m^3})}{10}
$$

Subsequently, we define the delta as the difference between the PM₂.₅ predicted value and the counterfactual:

$$
\Delta = (PM₂.₅_{\text{predicted}}) - (\text{Counterfactual})
$$

Finally, we calculate the relative risk as the exponential of the product of beta and the mean of the yearly delta:

$$
\text{Relative Risk} = \exp \left( \beta \times \text{mean}(\Delta_{\text{yearly}}) \right)
$$

## Results










<img src="figures_and_tables/fig_an_100.png" width="1920" />



## Quality check




