from pycompass import Connect, Compendium, Module, Sample, Platform, Experiment, Ontology, SampleSet, BiologicalFeature, Module

#Create a Connnect object and pass it the URL to point it to the COMPASS GraphQL endpoint
compass_url = 'http://compass.fmach.it/graphql'
conn = Connect(compass_url)
#compendia = conn.get_compendia()
#Since COMPASS is our interface to (possibily) many compendium,
#we'll list all of them and select the one we are interested in, i.e. VITIS_VINIFERA
vv_compendium = None
for compendium in conn.get_compendia():
    if compendium.compendium_name == 'vitis_vinifera':
        vv_compendium = compendium
        break

# ds = compendia[0].get_data_sources(fields=['sourceName'])
