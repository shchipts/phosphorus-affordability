#' Measures of competition for distributed DAP/MAP market model
#'
#' @seealso \code{\link{concentration.observed}}, 
#' \code{\link{diversification.observed}}, 
#' \code{\link{concentration.simulated}}, 
#' \code{\link{diversification.simulated}}
#' 
#' @docType package
#' @name dapmap.model
NULL

#' Market concentration observed by region and year
#' 
#' A normalized Herfindahl-Hirschman index of concentration (Hirschman 1964) by 
#' region for DAP/MAP fertilizer trade volumes 2013-2017.
#' 
#' The index of concentration takes the value 0 when a regional market is 
#' provided equally by all six suppliers (international suppliers + 
#' domestic industry), and approaches 1 when the market in question has 
#' a single supplier.
#' 
#' The following definitions apply: DAP - diammonium phosphate, MAP - monoammonium phosphate.
#' 
#' Regional classification includes: Africa, East Asia, Eastern Europe and Central Asia, Latin America, North America, Oceania, South Asia, Western and Central Europe, and Western Asia.
#'
#' @docType data
#'
#' @references 
#' \itemize{
#'   \item Hirschman, A. (1964). The Paternity of an Index. The American Economic Review, 54(5): 761.
#' }
"concentration.observed"

#' Market concentration simulated by region and scenario
#' 
#' A normalized Herfindahl-Hirschman index of concentration (Hirschman 1964) by
#' region for DAP/MAP fertilizer trade volumes in 2030 scenarios.
#' 
#' The index of concentration takes the value 0 when a regional market is 
#' provided equally by all six suppliers (international suppliers + 
#' domestic industry), and approaches 1 when the market in question has 
#' a single supplier.
#' 
#' The following definitions apply: DAP - diammonium phosphate, MAP - monoammonium phosphate.
#' 
#' The compilation covers 1000 bootstrap simulations by distributed DAP/MAP 
#' market model by FAO "Business as Usual" and "Stratified Societies" 
#' scenarios year 2030.
#' 
#' Regional classification includes: Africa, East Asia, Eastern Europe and Central Asia, Latin America, North America, Oceania, South Asia, Western and Central Europe, and Western Asia.
#'
#' @docType data
#'
#' @references 
#' \itemize{
#'   \item Hirschman, A. (1964). The Paternity of an Index. The American Economic Review, 54(5): 761.
#'   \item FAO. 2018. The future of food and agriculture - Alternative pathways to 2050. Rome.
#' }
"concentration.simulated"

#' Supplier diversification observed by region and year
#' 
#' An inverse normalized Herfindahl-Hirschman index of diversification 
#' (Berry 1971) by international supplier for DAP/MAP fertilizer trade volumes 
#' 2013-2017.
#' 
#' The index of diversification takes the value 0 when an international supplier
#' is active on a single market, and approaches 1 when the supplier in question 
#' sells in equal shares to all markets.
#' 
#' The following definitions apply: DAP - diammonium phosphate, MAP - monoammonium phosphate.
#' 
#' This compilation covers the following phosphate companies and groups of companies:
#' \itemize{
#'   \item Chinese exporters
#'   \item Maaden https://www.maaden.com.sa/
#'   \item Mosaic http://www.mosaicco.com/
#'   \item PhosAgro/EuroChem https://phosagro.com/, https://www.eurochemgroup.com/
#'   \item OCP https://www.ocpgroup.ma/
#' }
#'
#' @docType data
#'
#' @references 
#' \itemize{
#'   \item Berry, C. (1971). Corporate Growth and Diversification. Journal of Law and Economics, 14(2): 371-383.
#' }
"diversification.observed"

#' Supplier diversification observed by region and scenario
#' 
#' An inverse normalized Herfindahl-Hirschman index of diversification 
#' (Berry 1971) by international supplier for DAP/MAP fertilizer trade volumes 
#' in 2030 scenarios.
#' 
#' The index of diversification takes the value 0 when an international supplier
#' is active on a single market, and approaches 1 when the supplier in question 
#' sells in equal shares to all markets.
#' 
#' The following definitions apply: DAP - diammonium phosphate, MAP - monoammonium phosphate.
#' 
#' The compilation covers 1000 bootstrap simulations by distributed DAP/MAP 
#' market model by FAO "Business as Usual" and "Stratified Societies" 
#' scenarios year 2030.
#' 
#' This compilation covers the following phosphate companies and groups of companies:
#' \itemize{
#'   \item Chinese exporters
#'   \item Maaden https://www.maaden.com.sa/
#'   \item Mosaic http://www.mosaicco.com/
#'   \item PhosAgro/EuroChem https://phosagro.com/, https://www.eurochemgroup.com/
#'   \item OCP https://www.ocpgroup.ma/
#' }
#'
#' @docType data
#'
#' @references 
#' \itemize{
#'   \item Berry, C. (1971). Corporate Growth and Diversification. Journal of Law and Economics, 14(2): 371-383.
#'   \item FAO. 2018. The future of food and agriculture - Alternative pathways to 2050. Rome.
#' }
"diversification.simulated"