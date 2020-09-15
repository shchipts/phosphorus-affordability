NULL

#' Estimates of phosphorus use in crop production by region
#'
#' This compilation provides records on the regional phosphorus (P) use in crop production 
#' based on the IFA-IPNI assessment of fertilizer use 2014-2014/15. The compilation covers FAOSTAT crop production data for years 2007 to 2018, and
#' FAO "Business as Usual" and "Stratified Societies" scenarios crop production data for year 2030.
#' 
#' Metric tonnes of P2O5 per annum are used for volumes throughout this compilation.
#' 
#' P use is estimated based on the assumption that I/O relationship between p use and crop production by country-region present in 2014 remains constant as in baseline scenario in Daberkow, S., Poulisse, J., & Vroomen, H, (2000).
#' If crop was not produced in 2014, then default p application rate is used. Then, p use is aggregated by IFA region.
#' 
#' IFA-IPNI assesment of fertilizer use provides data on p use by 14 crop groups in 27 countries + EU-28 (94 percent of world consumption) and in the rest of the world (RoW) in calendar/fertilizer year 2014.
#'
#' Original data is mapped to p use by 12 crop groups in 55 countries and in the rest of 9 IFA regions using the following modifications:
#' \itemize{
#'   \item original data is scaled to replicate country-region p use from IFASTAT Consumption Database;
#'   \item "Grassland" and "Other Crops" categories in IFA-IPNI data are omitted;
#'   \item p uses in 28 european countries are derived from IFA-IPNI EU-28 p uses proportional to FAOSTAT crop production in these countries;
#'   \item p uses by crop in the rest of a region preserve proportions from RoW in the IFA-IPNI report;
#'   \item default p application rate by crop group and region is derived as the minimum application rate for a crop in a region.
#' }
#'
#' 
#' 
#' IFA regional classification includes 
#' \itemize{
#'   \item Africa
#'   \item East Asia
#'   \item Eastern Europe and Central Asia
#'   \item Latin America
#'   \item North America
#'   \item Oceania
#'   \item South Asia
#'   \item Western and Central Europe
#'   \item Western Asia
#' }
#' 
#' @docType data
#'
#' @format A data frame with 14 rows and 10 variables
#'
#' @references 
#' \itemize{
#'   \item IFA, & IPNI. (2017). Assessment of Fertilizer Use by Crop at the Global Level 2014-2014/15. Downloaded from https://www.ifastat.org/plant-nutrition
#'   \item FAO. 2018. The future of food and agriculture - Alternative pathways to 2050. Rome.
#' 	 \item FAOSTAT Crops database (2020). Downloaded from http://www.fao.org/faostat/en/#data/QC on Jun 2020.
#'   \item Daberkow, S., Poulisse, J., & Vroomen, H, (2000). Fertlizer Requirements in 2015 and 2030. FAO.
#' 	 \item IFASTAT Consumption database (2020). Downloaded from https://www.ifastat.org/databases/plant-nutrition on Jun 6th 2020. 	
#' }
"puse"

#' Phosphorus consumption in agriculture by region
#'
#' This compilation provides records on the regional phosphorus (P) consumption in agriculture
#' derived from the IFA Consumption database.
#'
#' Grand Total P2O5 values in the IFA Consumption database. 
#' Plant nutrition uses only (applications to crops, pastures, forests, fish ponds, turf, ornamentals). 
#' The consumption estimates provided in the Consumption Database relate, to the extent possible, to real consumption.
#' P consumption is aggregated by IFA region.
#' 
#' Metric tonnes of P2O5 per annum are used for volumes throughout this compilation.
#'
#' Countries are reported by ISO 3166 country code.
#'
#' @docType data
#'
#' @format A data frame with 11 rows and 10 variables
#' \itemize{
#	 \item Year: calendar year 
#'   \item Africa: p fertilizer consumption in countries
#' AGO, BDI, BEN, BFA, CAF, CIV, CMR, COD, COG, DJI, DZA, EGY, ERI, ETH, GAB, GHA, GIN, GMB, GNQ, KEN, LBR, LBY, MAR, MDG, MLI, MOZ, MRT, MUS, MWI, NAM, NER, NGA, RWA, SDN, SEN, SLE, SOM, SWZ, TCD, TGO, TUN, TZA, UGA, ZAF, ZMB, ZWE
#'   \item East Asia: p fertilizer consumption in countries
#' CHN, BRN, IDN, JPN, KHM, KOR, LAO, MMR, MNG, MYS, PHL, PRK, SGP, THA, TLS, VNM
#'   \item Eastern Europe and Central Asia: p fertilizer consumption in countries
#' ARM, AZE, BLR, EST, GEO, KAZ, KGZ, LTU, LVA, MDA, RUS, TJK, TKM, UKR, UZB
#'   \item Latin America: p fertilizer consumption in countries
#' ARG, ATG, BHS, BLZ, BMU, BOL, BRA, BRB, CHL, COL, CRI, CUB, CYM, DMA, DOM, ECU, GRD, GTM, GUY, HND, HTI, JAM, KNA, LCA, MEX, NIC, PAN, PER, PRY, SLV, SUR, TCA, TTO, URY, VCT, VEN
#'   \item North America: p fertilizer consumption in countries
#' CAN, USA
#'   \item Oceania: p fertilizer consumption in countries
#' AUS, FJI, NCL, NRU, NZL, PLW, PNG, PYF, SLB
#'   \item South Asia: p fertilizer consumption in countries
#' BGD, IND, LKA, NPL, PAK
#'   \item Western and Central Europe: p fertilizer consumption in countries
#' ALB, AUT, BEL, BGR, BIH, CHE, CZE, DEU, DNK, ESP, FIN, FRA, GBR, GRC, HRV, HUN, IRL, ISL, ITA, LUX, MKD, MNE, NLD, NOR, POL, PRT, ROU, SRB, SVK, SVN, SWE
#'   \item Western Asia: p fertilizer consumption in countries
#' AFG, ARE, BHR, CYP, IRN, IRQ, ISR, JOR, KWT, LBN, OMN, PSE, QAT, SAU, SYR, TUR, YEM
#' }
#' @references 
#' \itemize{
#' 	 \item IFASTAT Consumption database (2020). Downloaded from https://www.ifastat.org/databases/plant-nutrition on Jun 6th 2020. 	
#' }
"pconsumption"