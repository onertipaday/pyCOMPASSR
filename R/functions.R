#' Get a compendium by a given name, None otherwise
#'
#' @param url a string: the current url for compass GraphQL endpoint
#' @param species a string ('vitis_vinifera')
#'
#' @return a <pycompass.compendium.Compendium> object
#' @export
#'
#' @examples
#' vv_compendium <- get_compendium()
get_compendium <- function(url = 'http://compass.fmach.it/graphql', species='vitis_vinifera'){
  .check_pycompass()
  .pycompass$Connect(url)$get_compendia()[[1]]$connection$get_compendium(species)
}

#' Get the platform types
#'
#' @param compendium the compendium selected for the analysis
#'
#' @return a data.frame
#' @export
#'
#' @examples
#' vv_compendium <- get_compendium()
#' get_platform_types(compendium = vv_compendium)
get_platform_types <- function(compendium = get_compendium()){
  data.frame(t(sapply(compendium$get_platform_types(),unlist)))
  # data.frame(t(sapply(get_compendium()$get_platform_types(),unlist)))
  #data.frame(t(sapply(conn$get_platform_types(),unlist)))
}

#' Get the experiments data sources both local and public
#'
#' @param compendium the compendium selected for the analysis
#'
#' @return a data.frame
#' @export
#'
#' @examples
#' vv_compendium <- get_compendium()
#' get_data_sources(compendium = vv_compendium)
get_data_sources <- function(compendium = get_compendium()){
  data.frame(t(sapply(compendium$get_data_sources(),unlist)))
  # data.frame(t(sapply(get_compendium()$get_data_sources(),unlist)))
  # data.frame(t(sapply(conn$get_data_sources(),unlist)))
}

#' Rank all biological features on the module’s sample set using rank_method
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


#' Get biological feature
#'
#' @param compendium the compendium selected for the analysis
#' @param gene_names a vector of gene_ids
#'
#' @return a list of <pycompass.biological_feature.BiologicalFeature> objects
#' @export
#'
#' @examples
#' \dontrun{
#' gene_names <-c('VIT_05s0094g00350','VIT_07s0031g02630','VIT_19s0015g02480','VIT_08s0007g08840')
#' genes <- get_bf(compendium = get_compendium(), gene_names = as.list(gene_names))
#' }
get_bf <- function(compendium, gene_names){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(get_bf(compendium = compendium, gene_names = as.list(gene_names)))
  #BiologicalFeature.using(vv_compendium).get(filter={'name_In': gene_names})
  #junk=.pycompass$BiologicalFeature$using(vv_compendium)$get(filter = )
}

#' Create a new module
#'
#' @param compendium the compendium selected for the analysis
#' @param biofeatures a list of <pycompass.biological_feature.BiologicalFeature> objects from get_bf
#'
#' @return a "pycompass.module.Module"
#' @export
#'
#' @examples
#' \dontrun{
#' gene_names <-c('VIT_05s0094g00350','VIT_07s0031g02630','VIT_19s0015g02480','VIT_08s0007g08840')
#' genes <- get_bf(compendium = get_compendium(), gene_names = as.list(gene_names))
#' mod1 <- create_module(compendium = get_compendium, biofeatures = genes)
#' }
create_module <- function(compendium, biofeatures){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  my_module <- create_module(compendium, biofeatures)
  return(my_module)
  # return(my_module$values)
}

#' Add biological feature to the module
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

#' Get the HTML or JSON code that plot module heatmaps
#'
#' @param module a "pycompass.module.Module"
#'
#' @return a "xml_document"
#' @export
#'
#' @examples
#' \dontrun{
#' gene_names <-c('VIT_05s0094g00350','VIT_07s0031g02630','VIT_19s0015g02480','VIT_08s0007g08840')
#' genes <- get_bf(compendium = get_compendium(), gene_names = as.list(gene_names))
#' mod1 <- create_module(compendium = get_compendium, biofeatures = genes)
#' my_html <- plot_heatmap(mod1)
#' }
plot_heatmap <- function(module){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(xml2::read_html(plot_heatmap(module)))
  # write_html(tmp,file="test.html")
  # return(plot_heatmap(module))
}

#' Get the HTML or JSON code that plot module distributions
#'
#' @param module a "pycompass.module.Module"
#'
#' @return a "xml_document"
#' @export
#'
#' @examples
#' \dontrun{
#' gene_names <-c('VIT_05s0094g00350','VIT_07s0031g02630','VIT_19s0015g02480','VIT_08s0007g08840')
#' genes <- get_bf(compendium = get_compendium(), gene_names = as.list(gene_names))
#' mod1 <- create_module(compendium = get_compendium, biofeatures = genes)
#' my_plot_dist <- plot_distribution(mod1)
#' }
plot_distribution <- function(module){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(xml2::read_html(plot_distribution(module)))
}


#' Get the HTML or JSON code that plot the module networks
#'
#' @param module a "pycompass.module.Module"
#'
#' @return  a "xml_document"
#' @export
#'
#' @examples
#' \dontrun{
#' gene_names <-c('VIT_05s0094g00350','VIT_07s0031g02630','VIT_19s0015g02480','VIT_08s0007g08840')
#' genes <- get_bf(compendium = get_compendium(), gene_names = as.list(gene_names))
#' mod1 <- create_module(compendium = get_compendium, biofeatures = genes)
#' my_plot_net <- plot_network(mod1)
#' }
plot_network <- function(module){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(xml2::read_html(plot_network(module)))
}


