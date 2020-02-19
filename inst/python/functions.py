from pycompass import BiologicalFeature, Module, Plot

def get_bf(compendium, gene_names):
  return BiologicalFeature.using(compendium).get(filter={'name_In': gene_names})

def create_module(compendium, biofeatures):
  return  Module.using(compendium).create(biofeatures, normalization='legacy')
  
def add_module(compendium, module, new_genes):
  return module.add_biological_features(new_genes)
  
def diff_module(module_1, module_2, sample_sets=False):
  return Module.difference(module_2, module_1, sample_sets=sample_sets)

def plot_heatmap(module):
  return Plot(module).plot_heatmap()

def plot_distribution(module): 
  return Plot(module).plot_distribution(plot_type='biological_features_standard_deviation_distribution')
  
def plot_network(module): 
  return Plot(module).plot_network()
  
# Non funzionano! -------------------------------------------------------------
# def save_module(module, filename='module.vsp'):
#   return module.write_to_file(filename)
# #
# def load_module(filename='module.vsp', connection):
#   return Module.read_from_file(filename, connection)
#------------------------------------------------------------------------------
