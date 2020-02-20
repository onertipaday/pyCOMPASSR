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
#' @param module a Module object
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
#' @return list of BiologicalFeature objects
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

#' Create a new module providing biological featurers (genes)
#'
#' @param compendium the compendium selected for the analysis
#' @param biofeatures list of BiologicalFeature objects from get_bf
#' @param normalization  the normalization to be used for the inference ('legacy' as default)
#'
#' @return a Module object
#' @export
create_module_bf<- function(compendium, biofeatures, normalization = 'legacy'){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  create_module_bf(compendium, biofeatures, normalization='legacy')
}


#' Create a new module providing Sample sets
#'
#' @param compendium the compendium selected for the analysis
#' @param samplesets a list of <samplesets> objects from get_ss
#' @param normalization  the normalization to be used for the inference ('legacy' as default)
#'
#'
#' @return a Module object
#' @export
create_module_ss<- function(compendium, samplesets, normalization='legacy'){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  create_module_ss(compendium, samplesets, normalization='legacy')
}

#' Create a new module joining two modules
#'
#' @param module_1  a Module object
#' @param module_2  a Module object
#'
#' @return a Module object
#' @export
join_modules <- function(module_1, module_2){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  join_modules(module_1, module_2)
}

#' Create a new module
#'
#' @param compendium the compendium selected for the analysis
#' @param biofeatures list of BiologicalFeature objects from get_bf
#' @param samplesets a list of <samplesets> objects from get_ss
#' @param normalization  the normalization to be used for the inference ('legacy' as default)
#'
#' @return a Module object
#' @export
#'
#' @examples
#' \dontrun{
#' gene_names <-c('VIT_05s0094g00350','VIT_07s0031g02630','VIT_19s0015g02480','VIT_08s0007g08840')
#' genes <- get_bf(compendium = get_compendium(), gene_names = as.list(gene_names))
#' mod1 <- create_module(compendium = get_compendium, biofeatures = genes)
#' }
create_module <- function(compendium, biofeatures = NULL, samplesets = NULL, normalization = 'legacy'){
  #reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  if(is.null(biofeatures) & is.null(samplesets)) stop("You need to provide at least a biofeatures object or samplesets object")
    else if (is.null(biofeatures)){
      out <- create_module_ss(compendium, samplesets, normalization)
    }
    else if (is.null(samplesets)){
      out <- create_module_bf(compendium, biofeatures, normalization)
    }
    else{
      mod1 <- create_module_ss(compendium, samplesets, normalization)
      mod2 <- create_module_bf(compendium, biofeatures, normalization)
      out <- join_modules(mod1, mod2)
    }
    out
}

#' Add biological feature to the module
#'
#' @param compendium the compendium selected for the analysis
#' @param module a Module object
#' @param new_genes a list of gene_names
#'
#' @return a Module object
#' @export
add_module <- function(compendium, module, new_genes){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(add_module(compendium, module, new_genes))
}
# -----------------------------------------------------------------------------
# Plot functions

#' Get the HTML or JSON code that plot module heatmaps
#'
#' @param module a Module object
#' @param output_format a string: either 'html' (default) or 'json'
#' @param alternativeColoring alternative color blind friendly palette (default 'TRUE')
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
plot_heatmap <- function(module, output_format='html', alternativeColoring=TRUE){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(xml2::read_html(plot_heatmap(module, output_format, alternativeColoring)))
  # write_html(tmp,file="test.html")
  # return(plot_heatmap(module))
}

#' Get the HTML or JSON code that plot module distributions
#'
#' @param module a Module object
#' @param plot_type type of plot, select from:
#'  - 'biological_features_standard_deviation_distribution' (default)
#'  - 'sample_sets_magnitude_distribution'
#'
#' @param output_format a string: either 'html' (default) or 'json'
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
plot_distribution <- function(module, output_format='html', plot_type='biological_features_standard_deviation_distribution'){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(xml2::read_html(plot_distribution(module, output_format, plot_type)))
}


#' Get the HTML or JSON code that plot the module networks
#'
#' @param module a Module object
#' @param output_format a string: either 'html' (default) or 'json'
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
plot_network <- function(module, output_format='html'){
  reticulate::source_python(system.file("python", "functions.py", package = "pyCOMPASSR"))
  return(xml2::read_html(plot_network(module, output_format)))
}


