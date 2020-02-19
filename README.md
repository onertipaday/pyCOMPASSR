# pyCOMPASSR is a R wrapper to the python library 'pyCOMPASS' 

pyCOMPASS allow querying COMPASS (COMpendia Programmatic Access Support Software) a software layer that provides a GraphQL endpoint to query compendia built using COMMAND>_ technology.

# Installation

## 1. Install `python` and `pip`

1.1. Install `python 3` (>= 3.3) ([download page](https://www.python.org/downloads))

1.2. Install `pip` for `python`

1.3. Install `reticulate` for R

```
install.packages("reticulate")
```

1.4. Check that `reticulate` can now find `python`. You may have to restart RStudio.

```
reticulate::py_config()
```

You will see information about your python configuration, including one or more system paths where python is installed.

1.5. Check that `pip` can be found

```
system("pip --version")
```

You will see something like `pip 19.1.1 from /usr/lib/python3.7/site-packages/pip (python 3.7)`

## 2. Install `pyCOMPASS`

2.1. Find the default `python` path that `reticulate` is using

```
reticulate::py_config()
```

Take note of the path in the first line (e.g., "/usr/bin/python").

2.2. Find the path that the system `pip` command is using

```
system("pip --version")
```

For example, in "pip 19.1.1 from /usr/lib/python3.7/site-packages/pip (python 3.7)" the `python` path is "/usr/lib/python3.7". If the path here does not match the py_config() path, then you may need to manually set the path using `use_python()`.

```
reticulate::use_python("/usr/lib/python3.7", required = TRUE)
```

You may have to restart RStudio before setting the path if you have run other `reticulate` operations.

2.3. Install `pycompass` from R

```
# create a new environment 
virtualenv_create("pycompassr")
# install pycompass
virtualenv_install("pycompassr", "pycompass")
```

2.3. Install `pyCOMPASS` using `pip`

```
system("pip install pycompass")
```

Or alternatively, run this command in the system terminal (`sudo pip install pycompass` for Mac users).

2.4. Check if you can now import pyCOMPASS. You may have to restart RStudio.

```
pycompass <- reticulate::import("pycompass")
```

## 3. Install `pyCOMPASSR`

3.1. Finally, you can install `pyCOMPASSR`.

```
remotes::install_github("onertipaday/pyCOMPASSR")
```

# Usage

Load the library
```{r}
library(pyCOMPASSR)
```
Create a Connect object and pass the URL wich points it to the COMPASS GraphQL endpoint
```{r}
my_conn <- get_connection(url = 'http://compass.fmach.it/graphql')
```
Since COMPASS is our interface to (possibily) many compendium, we'll list all of them and select the one we are interested in, i.e. VITIS_VINIFERA
```{r}
vv_compendium <- get_compendium(species = 'vitis_vinifera')
print(vv_compendium$description)
```
Let's build our module starting from a bunch of genes 
```{r}
gene_names <-c('VIT_05s0094g00350','VIT_07s0031g02630','VIT_19s0015g02480','VIT_08s0007g08840','VIT_01s0026g00520','VIT_03s0017g02170','VIT_19s0014g05330','VIT_02s0154g00130','VIT_02s0025g04330','VIT_13s0067g00490','VIT_09s0002g01200','VIT_14s0030g00140','VIT_03s0063g00120','VIT_05s0029g01480','VIT_11s0052g01650','VIT_02s0087g01020','VIT_09s0070g00160','VIT_13s0019g02180','VIT_07s0095g00550','VIT_04s0008g06570','VIT_04s0069g00860','VIT_04s0210g00060','VIT_07s0104g00430','VIT_15s0107g00210','VIT_16s0039g00970','VIT_10s0003g01730','VIT_17s0000g07060','VIT_16s0100g00510','VIT_02s0154g00590')
```
We can query the compendium with the list of gene names and get a list of BiologicalFeature objects that represents our genes of interest.

```{r}
genes <- get_bf(compendium = vv_compendium, gene_names = as.list(gene_names))
```
We are now ready to create our first module: the compendium will need the list of genes (BiologicalFeature objects) and the name of the normalization we want to use in order to automatically select the "best" conditions.¶

```{r}
mod1 <- create_module(compendium = vv_compendium, biofeatures = genes)
```
A module is a matrix that represent a portion of genes and a portion of conditions of the whole compendium. Let's see its values.

```{r}
mod1$compendium$compendium_full_name
mod1$values
```
Now we will plot the heatmap for this module using the Plot object. The plot_heatmap method will return normal HTML + Javascript code so since we are using a web-browser to display thing we will just need to tell Jupyter to interpret the HTML + Javascript code for us¶
```{r}
my_plot_html <- plot_heatmap(mod1)
tempDir <- tempfile()
dir.create(tempDir)
htmlFile <- file.path(tempDir, "plot_heatmap.html")
write_html(my_plot_html,file=htmlFile)
rstudioapi::viewer(htmlFile)
```

# Changelog

For development updates see the [changelog](https://github.com/onertipaday/pyCOMPASSR/blob/master/CHANGELOG.md).

# Package maintainer / author

pyCOMPASSR is written and maintained by [Paolo Sonego](https://github.com/onertipaday).
pyCOMPASS is written and mantained by [MarcoMoretto](https://github.com/marcomoretto/pyCOMPASS)
<a href="https://twitter.com/intent/follow?screen_name=onertipaday"><img src="https://img.shields.io/twitter/follow/onertipaday?style=social&logo=twitter" alt="follow on Twitter"></a>


