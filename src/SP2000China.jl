module SP2000China

# Load required packages
using HTTP,JSON,URIParser,DataFrames,ProgressMeter

# Load scripts
include("01_api_v2_getFamiliesByFamilyName.jl")
include("02_api_v2_getSpeciesByFamilyId.jl")
include("03_api_v2_getSpeciesByScientificName.jl")
include("04_api_v2_getSpeciesByCommonName.jl")
include("05_api_v2_getSpeciesByNameCode.jl")
include("06_api_v2_getNameByKeyword.jl")
include("07_net_tools.jl")
include("08_local_tools.jl")

# Export functions
export GetFamiliesByFamilyName
export GetSpeciesByFamilyId
export GetSpeciesByScientificName
export GetSpeciesByCommonName
export GetSpeciesByNameCode
export GetNameByKeyword
export Chinese2Latin,FindUnknown
export Latin2GenusSpecies,DfSearch,StrSearch

# Description
"""
The Julia package for obtaining information on the list of biological species, SP2000China.
"""
SP2000China

end 
