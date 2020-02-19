#' Connect to a COMPASS GraphQL endpoint
#'
#' @param url a string: the current url for compass graphql API
#'
#' @return a <pycompass.compendium.Compendium> object
#' @export
#'
#' @examples
#' conn=get_connection(url = 'http://compass.fmach.it/graphql')
get_connection <- function(url = 'http://compass.fmach.it/graphql'){
  .check_pycompass()
  # connection <- reticulate::py_run_file(system.file("python", "connect.py", package = "pyCOMPASSR"))
  #pycompass <- reticulate::import("pycompass")
  #pycompass$Connect(url)$get_compendia()[[1]]
  .pycompass$Connect(url)$get_compendia()[[1]]
}

#' get_compendium
#'
#' @description Get a compendium by a given name, NULL otherwise
#'
#' @param species a string ('vitis_vinifera')
#'
#' @return a <pycompass.compendium.Compendium> object
#' @export
#'
#' @examples
get_compendium <- function(species='vitis_vinifera'){
  get_connection(url = 'http://compass.fmach.it/graphql')$connection$get_compendium(species)
}


#' get_platform_types
#'
#' @param conn a <pycompass.compendium.Compendium> object
#'
#' @return a data.frame
#' @export
#'
#' @examples
#' my_conn <- get_connection()
#' get_platform_types(conn = my_conn)
get_platform_types <- function(conn = get_connection()){
#  data.frame(t(sapply(get_compendium()$get_platform_types(),unlist)))
  data.frame(t(sapply(conn$get_platform_types(),unlist)))
}

#' get_data_sources
#'
#' @param conn a <pycompass.compendium.Compendium> object
#'
#' @return a data.frame
#' @export
#'
#' @examples
#' my_conn <- get_connection()
#' get_data_sources(conn = my_conn)
get_data_sources <- function(conn = get_connection()){
  data.frame(t(sapply(conn$get_data_sources(),unlist)))
}

#' rank genes
#'
#' @param compendium the compendium selected for the analysis
#' @param module a "pycompass.module.Module"
#' @param rank_method ranking method (default 'std')
#'
#' @return a data.frame
#' @export
#'
#' @examples
#'  \dontrun{
#' ranked_genes <- rank_genes()
#' }
rank_genes <- function(compendium = get_compendium(), module, rank_method = "std"){
  as.data.frame(compendium$rank_biological_features(module, rank_method)$ranking)
}

# get_biological_features <- function(conn = get_connection(), genes = gene_names){
#   pycompass <- reticulate::import("pycompass")
#   vv_compendium <- conn$connection$get_compendium('vitis_vinifera')
#   # genes = BiologicalFeature.using(vv_compendium).get(filter={'name_In': gene_names})
#   my_filter <- reticulate::dict(keys = 'name_In', values = as.list(gene_names))
#   bf <-  pycompass$BiologicalFeature$using(vv_compendium)
#   genes <- bf$get(filter = my_filter)
#   genes
# }

## Using python scripts


#' get_bf
#'
#' @param compendium the compendium selected for the analysis
#' @param gene_names a vector of gene_ids
#'
#' @return a list of <pycompass.biological_feature.BiologicalFeature> objects
#' @export
#'
#' @examples
#' \dontrun{
#' my_conn <- get_connection(url = 'http://compass.fmach.it/graphql')
#' vv_compendium <- my_conn$connection$get_compendium('vitis_vinifera')
#' gene_names <-c('VIT_05s0094g00350','VIT_07s0031g02630','VIT_19s0015g02480','VIT_08s0007g08840')
#' genes <- get_bf(compendium = vv_compendium, gene_names = as.list(gene_names))
#' }
get_bf <- function(compendium, gene_names){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(get_bf(compendium = compendium, gene_names = as.list(gene_names)))
  #BiologicalFeature.using(vv_compendium).get(filter={'name_In': gene_names})
  #junk=.pycompass$BiologicalFeature$using(vv_compendium)$get(filter = )
}

#' create_module
#'
#' @param compendium the compendium selected for the analysis
#' @param biofeatures a list of <pycompass.biological_feature.BiologicalFeature> objects from get_bf
#'
#' @return a "pycompass.module.Module"
#' @export
#'
#' @examples
#' \dontrun{
#' mod1 <- create_module(compendium = get_connection()$vv_compendium, biofeatures = genes)
#' }
create_module <- function(compendium, biofeatures){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  my_module <- create_module(compendium, biofeatures)
  return(my_module)
  # return(my_module$values)
}

#' Title
#'
#' @param compendium the compendium selected for the analysis
#' @param module a "pycompass.module.Module"
#' @param new_genes a list of gene_names
#'
#' @return a "pycompass.module.Module"
#' @export
#'
#' @examples
add_module <- function(compendium, module, new_genes){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(add_module(compendium, module, new_genes))
}

# -----------------------------------------------------------------------------
# NON FUNZIONANO!!!
# save_module <- function(module, filename = "module.vsp"){
#   .check_pycompass()
#   reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
#   save_module(module, filename)
# }
#
# load_module <- function(filename = "module.vsp", connection){
#   .check_pycompass()
#   reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
#   load_module(filename, connection)
# }
# -----------------------------------------------------------------------------

#' plot_heatmap
#'
#' @param module a "pycompass.module.Module"
#'
#' @return a "xml_document"
#' @export
#'
#' @examples
#' \dontrun{
#' mod1 <- create_module(get_connection()$vv_compendium, genes)
#' my_html <- plot_heatmap(mod1)
#' }
plot_heatmap <- function(module){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(xml2::read_html(plot_heatmap(module)))
  # write_html(tmp,file="test.html")
  # return(plot_heatmap(module))
}

#' plot biological_features_standard_deviation_distribution
#'
#' @param module a "pycompass.module.Module"
#'
#' @return a "xml_document"
#' @export
#'
#' @examples
#' \dontrun{
#' mod1 <- create_module(get_connection()$vv_compendium, genes)
#' my_plot_dist <- plot_distribution(mod1)
#' }
plot_distribution <- function(module){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(xml2::read_html(plot_distribution(module)))
}


