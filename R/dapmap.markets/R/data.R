NULL

#' DAP/MAP fertilizer trade volumes 2013-2017
#'
#' This compilation provides records on the regional DAP/MAP fertilizer trade volumes estimated from 
#' the UN Comtrade data, IFA Supply Database and data announced by global phosphate companies. 
#' 
#' The following definitions apply: DAP - diammonium phosphate, MAP - monoammonium phosphate.
#'
#' This compilation covers the period from 2013 to 2017.
#'
#' Countries are reported by ISO 3166 country code.
#'
#' This compilation covers the following phosphate companies and groups of companies:
#' \itemize{
#'   \item China (export): Chinese exporters
#'   \item Maaden: Maaden website: https://www.maaden.com.sa/
#'   \item Mosaic: Mosaic website: http://www.mosaicco.com/
#'   \item PhosAgro/EuroChem: PhosAgro, EuroChem website: https://phosagro.com/, https://www.eurochemgroup.com/
#'   \item OCP: OCP website: https://www.ocpgroup.ma/
#' }
#'
#' The fertilizer sales volume from regional producers and other importers are recorded under Home and Other Imports; the values are estimated as the difference between consumption reported in the IFA Supply Database and total sales of the global companies into a region.
#'
#' Metric tonnes of P2O5 per annum are used for volumes throughout this compilation.
#' Original data values are recorded in kilograms in the UN Comtrade Database.
#' Original data values are recorded in metric tonnes of product in the IFA Supply Database and in the compiled global phosphate companies data.
#'
#' The following conversion factors of product to P2O5 volumes were applied:
#' \itemize{
#'   \item DAP   0.46
#'   \item MAP   0.52
#'   \item MAP (China)   0.44
#'   \item DAP/MAP   0.49
#' }
#'
#' @docType data
#'
#' @format A data frame with 30 rows and 11 variables
#' \itemize{
#'   \item Producer: company or a group of companies
#'   \item Year: year of operations
#'   \item Africa: producer's trade volume with countries
#' AGO, BDI, BEN, BFA, CAF, CIV, CMR, COD, COG, DJI, DZA, EGY, ERI, ETH, GAB, GHA, GIN, GMB, GNQ, KEN, LBR, LBY, MAR, MDG, MLI, MOZ, MRT, MUS, MWI, NAM, NER, NGA, RWA, SDN, SEN, SLE, SOM, SWZ, TCD, TGO, TUN, TZA, UGA, ZAF, ZMB, ZWE
#'   \item East Asia: producer's trade volume with countries
#' CHN, BRN, IDN, JPN, KHM, KOR, LAO, MMR, MNG, MYS, PHL, PRK, SGP, THA, TLS, VNM
#'   \item Eastern Europe and Central Asia: producer's trade volume with countries
#' ARM, AZE, BLR, EST, GEO, KAZ, KGZ, LTU, LVA, MDA, RUS, TJK, TKM, UKR, UZB
#'   \item Latin America: producer's trade volume with countries
#' ARG, ATG, BHS, BLZ, BMU, BOL, BRA, BRB, CHL, COL, CRI, CUB, CYM, DMA, DOM, ECU, GRD, GTM, GUY, HND, HTI, JAM, KNA, LCA, MEX, NIC, PAN, PER, PRY, SLV, SUR, TCA, TTO, URY, VCT, VEN
#'   \item North America: producer's trade volume with countries
#' CAN, USA
#'   \item Oceania: producer's trade volume with countries
#' AUS, FJI, NCL, NRU, NZL, PLW, PNG, PYF, SLB
#'   \item South Asia: producer's trade volume with countries
#' BGD, IND, LKA, NPL, PAK
#'   \item Western and Central Europe: producer's trade volume with countries
#' ALB, AUT, BEL, BGR, BIH, CHE, CZE, DEU, DNK, ESP, FIN, FRA, GBR, GRC, HRV, HUN, IRL, ISL, ITA, LUX, MKD, MNE, NLD, NOR, POL, PRT, ROU, SRB, SVK, SVN, SWE
#'   \item Western Asia: producer's trade volume with countries
#' AFG, ARE, BHR, CYP, IRN, IRQ, ISR, JOR, KWT, LBN, OMN, PSE, QAT, SAU, SYR, TUR, YEM
#' }
#'
#' @references 
#' \itemize{
#'   \item UN Comtrade Database, downloaded from https://comtrade.un.org/ in Oct 2020
#'
#' 	 \item IFA Supply Database, downloaded from https://www.ifastat.org/supply/Phosphate\%20Products/Processed\%20Phosphates in Jun 2020
#'   \item EuroChem 2013 Annual Report And Accounts: "Helping The World Grow". Downloaded from https://www.eurochemgroup.com/investors/reports-results/
#' 	 \item EuroChem Q4 2014 Press Release: "EuroChem Group AG Reports IFRS Financial Information for 2014". Downloaded from https://www.eurochemgroup.com/investors/reports-results/
#' 	 \item EuroChem 2016 Annual Report And Accounts: "Keeping Our Focus". Downloaded from https://www.eurochemgroup.com/investors/reports-results/
#' 	 \item EuroChem 2017 Annual Report And Accounts: "Building Momentum". Downloaded from https://www.eurochemgroup.com/investors/reports-results/
#'
#' 	 \item Maaden Annual Report 2013: "Driving Development". Downloaded from https://www.maaden.com.sa/en/investor/report
#' 	 \item Maaden Annual Report 2014: "Delivering Results". Downloaded from https://www.maaden.com.sa/en/investor/report
#' 	 \item Maaden Annual Report 2015: "Mining For Shareholder Value And National Development". Downloaded from https://www.maaden.com.sa/en/investor/report
#' 	 \item Maaden Annual Report 2016: "Facing Today's Challenges". Downloaded from https://www.maaden.com.sa/en/investor/report
#' 	 \item Maaden Annual Report 2017: "Building A Sustainable Future". Downloaded from https://www.maaden.com.sa/en/investor/report
#'
#' 	 \item CF Industries 2013 Annual Report: "Momentum". Downloaded from http://www.snl.com/IRW/FinancialDocs/4533245
#' 	 \item Mosaic 2015 Annual Report. Downloaded from http://investors.mosaicco.com/CorporateProfile
#' 	 \item Mosaic 2016 Annual Report. Downloaded from http://investors.mosaicco.com/CorporateProfile
#' 	 \item Mosaic 2017 Annual Report. Downloaded from http://investors.mosaicco.com/CorporateProfile
#'
#' 	 \item OCP S.A. Note d'information - Emission Obligataire OCP SA 2018. Downloaded from http://www.casablanca-bourse.com/bourseweb/index.aspx
#'
#' 	 \item PhosAgro Annual Report 2013: "What Quality Means To Us". Downloaded from https://phosagro.com/investors/reports/year/
#' 	 \item PhosAgro Integrated Report 2014: "Moving Closer To Key Markets". Downloaded from https://phosagro.com/investors/reports/year/
#' 	 \item PhosAgro Integrated Report 2015: "Creating Value For Farmers". Downloaded from https://phosagro.com/investors/reports/year/
#' 	 \item PhosAgro Integrated Report 2016: "The Phosphate Journey: From Mine to Plate". Downloaded from https://phosagro.com/investors/reports/year/
#' 	 \item PhosAgro Integrated Report 2017: "Growth, Efficiency, Value". Downloaded from https://phosagro.com/investors/reports/year/
#' }
"dapmap.markets"

#' DAP/MAP consumption by region
#'
#' This compilation provides records on the DAP/MAP fertilizer consumption estimated from the IFA Supply Database.
#' 
#' The following definitions apply: DAP - diammonium phosphate, MAP - monoammonium phosphate.
#'
#' This compilation covers the period from 2007 to 2018.
#'
#' Countries are reported by ISO 3166 country code.
#'
#' Values are exported as aggregated DAP and MAP apparent consumption by region in the IFA Supply Database.
#'
#' Metric tonnes of P2O5 per annum are used for volumes throughout this compilation.
#' Original data values are recorded in metric tonnes of product.
#'
#' The following conversion factors of product to P2O5 volumes were applied:
#' \itemize{
#'   \item DAP   0.46
#'   \item MAP   0.52
#' }
#'
#' @docType data
#'
#' @format A data frame with 12 rows and 10 variables
#' \itemize{
#'   \item Year: year of operations
#'   \item Africa: dap/map consumption in countries
#' AGO, BDI, BEN, BFA, CAF, CIV, CMR, COD, COG, DJI, DZA, EGY, ERI, ETH, GAB, GHA, GIN, GMB, GNQ, KEN, LBR, LBY, MAR, MDG, MLI, MOZ, MRT, MUS, MWI, NAM, NER, NGA, RWA, SDN, SEN, SLE, SOM, SWZ, TCD, TGO, TUN, TZA, UGA, ZAF, ZMB, ZWE
#'   \item East Asia: dap/map consumption in countries
#' CHN, BRN, IDN, JPN, KHM, KOR, LAO, MMR, MNG, MYS, PHL, PRK, SGP, THA, TLS, VNM
#'   \item Eastern Europe and Central Asia: dap/map consumption in countries
#' ARM, AZE, BLR, EST, GEO, KAZ, KGZ, LTU, LVA, MDA, RUS, TJK, TKM, UKR, UZB
#'   \item Latin America: dap/map consumption in countries
#' ARG, ATG, BHS, BLZ, BMU, BOL, BRA, BRB, CHL, COL, CRI, CUB, CYM, DMA, DOM, ECU, GRD, GTM, GUY, HND, HTI, JAM, KNA, LCA, MEX, NIC, PAN, PER, PRY, SLV, SUR, TCA, TTO, URY, VCT, VEN
#'   \item North America: dap/map consumption in countries
#' CAN, USA
#'   \item Oceania: dap/map consumption in countries
#' AUS, FJI, NCL, NRU, NZL, PLW, PNG, PYF, SLB
#'   \item South Asia: dap/map consumption in countries
#' BGD, IND, LKA, NPL, PAK
#'   \item Western and Central Europe: dap/map consumption in countries
#' ALB, AUT, BEL, BGR, BIH, CHE, CZE, DEU, DNK, ESP, FIN, FRA, GBR, GRC, HRV, HUN, IRL, ISL, ITA, LUX, MKD, MNE, NLD, NOR, POL, PRT, ROU, SRB, SVK, SVN, SWE
#'   \item Western Asia: dap/map consumption in countries
#' AFG, ARE, BHR, CYP, IRN, IRQ, ISR, JOR, KWT, LBN, OMN, PSE, QAT, SAU, SYR, TUR, YEM
#' }
#'
#' @references 
#' \itemize{
#' 	 \item IFA Supply Database, downloaded from https://www.ifastat.org/supply/Phosphate\%20Products/Processed\%20Phosphates in Jun 2020
#' }
"dapmap.consumption"