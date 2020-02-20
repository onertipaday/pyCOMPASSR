from pycompass import BiologicalFeature, Module, Plot

def get_bf(compendium, gene_names):
  return BiologicalFeature.using(compendium).get(filter={'name_In': gene_names})

def create_module_bf(compendium, biofeatures, normalization='legacy'):
  return Module.using(compendium).create(biofeatures, normalization=normalization)

def create_module_ss(compendium, samplesets, normalization='legacy'):
  return Module.using(compendium).create(samplesets, normalization=normalization)

def add_module(compendium, module, new_genes):
  return module.add_biological_features(new_genes)
  
def join_modules(module_1, module_2):
  return Module.union(module_2, module_1)

def diff_module(module_1, module_2, sample_sets=False):
  return Module.difference(module_2, module_1, sample_sets=sample_sets)

def plot_heatmap(module,alternativeColoring=True):
  return Plot(module).plot_heatmap(alternativeColoring=alternativeColoring)

def plot_distribution(module, plot_type='biological_features_standard_deviation_distribution'):
  return Plot(module).plot_distribution(plot_type=plot_type)
  
# def plot_distribution(module, plot_type): 
#   return Plot(module).plot_distribution(plot_type='biological_features_standard_deviation_distribution')
#   
def plot_network(module): 
  return Plot(module).plot_network()
  
