from pycompass import BiologicalFeature, SampleSet, Ontology, Experiment, Platform, Module, Plot


def get_platform_info(compendium):
  return Platform.using(compendium).get(fields=['platformAccessId'], filter={'first': 2})

def get_bf(compendium, gene_names):
  return BiologicalFeature.using(compendium).get(filter={'name_In': gene_names})

def get_ss(compendium, sample_names):
  return SampleSet.using(compendium).get(filter={'name_In': sample_names})

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

def plot_heatmap(module, output_format='html', alternativeColoring=True):
  return Plot(module).plot_heatmap(output_format=output_format, alternativeColoring=alternativeColoring)

def plot_distribution(module, output_format='html', plot_type='biological_features_standard_deviation_distribution'):
  return Plot(module).plot_distribution(output_format=output_format, plot_type=plot_type)
  
def plot_network(module, output_format='html'): 
  return Plot(module).plot_network(output_format=output_format)
