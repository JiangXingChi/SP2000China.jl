var documenterSearchIndex = {"docs":
[{"location":"#SP2000China.jl","page":"User's guide","title":"SP2000China.jl","text":"","category":"section"},{"location":"","page":"User's guide","title":"User's guide","text":"The Julia package for obtaining information on the list of biological species, SP2000China.\nTo use this package, you need to register on the Species 2000 China website (http://www.sp2000.org.cn/) and obtain API services.\nTo install this package, you can use the following command:","category":"page"},{"location":"","page":"User's guide","title":"User's guide","text":"using Pkg\nPkg.add(\"SP2000China\")","category":"page"},{"location":"function/#Function","page":"Function","title":"Function","text":"","category":"section"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetFamiliesByFamilyName","category":"page"},{"location":"function/#SP2000China.GetFamiliesByFamilyName","page":"Function","title":"SP2000China.GetFamiliesByFamilyName","text":"GetFamiliesByFamilyName(;family_name::String,api_key::String,page::Int=1)\n\nDescription\n\nQuery by family name and return a collection of family IDs.\n\nParameters\n\nfamily_name: The family name, or a part of it, supporting both Latin and Chinese names.\napi_key: The API service key for registered users.\npage: The page number, an integer not less than 1. If not provided, it defaults to 1.\n\nResults\n\nresult: A structure of type GetFamiliesByFamilyNameStruct.\nresult.data: Dictionary converted from JSON information.\nresult.count: Total number of matches.\nresult.page: Current data page.\nreult.limit: Number of items displayed per page.\nresult.abstract: Refined data frame.\n\nExample\n\nusing SP2000China;\nyour_family_name = \"Coriariaceae\";\nyour_api_key = \"Please register an account and obtain an API key\";\nyour_page = 1;\nresult = GetFamiliesByFamilyName(family_name=your_family_name,api_key=your_api_key,page=your_page);\nresult.data\nresult.count\nresult.page\nreult.limit\nresult.abstract\n\n\n\n\n\n","category":"function"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetSpeciesByFamilyId","category":"page"},{"location":"function/#SP2000China.GetSpeciesByFamilyId","page":"Function","title":"SP2000China.GetSpeciesByFamilyId","text":"GetSpeciesByFamilyId(;family_id::String,api_key::String,page::Int=1)\n\nDescription\n\nQuery species by family ID and return a list of species.\n\nParameters\n\nfamily_id:The family ID, a unique value.\napi_key:The API service key for registered users.\npage:The page number, an integer not less than 1. Defaults to 1 if not provided.\n\nResults\n\nresult: A structure of type GetSpeciesByFamilyIdStruct.\nresult.data: Dictionary converted from JSON information.\nresult.count: Total number of matches.\nresult.page: Current data page.\nresult.limit: Number of items displayed per page.\nresult.abstract: Refined data frame.\n\nExample\n\nusing SP2000China;\nyour_family_id = \"F20171000000291\";\nyour_api_key = \"Please register an account and obtain an API key\";\nyour_page = 1;\nresult = GetSpeciesByFamilyId(family_id=your_family_id,api_key=your_api_key,page=your_page);\nresult.data\nresult.count\nresult.page\nreult.limit\nresult.abstract\n\n\n\n\n\n","category":"function"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetSpeciesByScientificName","category":"page"},{"location":"function/#SP2000China.GetSpeciesByScientificName","page":"Function","title":"SP2000China.GetSpeciesByScientificName","text":"GetSpeciesByScientificName(;scientific_name::String,api_key::String,page::Int=1)\n\nDescription\n\nQuery by scientific name and return species IDs.\n\nParameters\n\nscientific_name:The scientific name, or a part of it, supporting both Latin and Chinese names.\napi_key: The API service key for registered users.\npage: The page number, an integer not less than 1. If not provided, it defaults to 1.\n\nResults\n\nresult: A structure of type GetSpeciesByScientificNameStruct.\nresult.data: Dictionary converted from JSON information.\nresult.count: Total number of matches.\nresult.page: Current data page.\nreult.limit: Number of items displayed per page.\nresult.abstract: Refined data frame.\n\nExample\n\nusing SP2000China;\nyour_scientific_name = \"Actinidia arg\";\nyour_api_key = \"Please register an account and obtain an API key\";\nyour_page = 1;\nresult = GetSpeciesByScientificName(scientific_name=your_scientific_name,api_key=your_api_key,page=your_page);\nresult.data\nresult.count\nresult.page\nreult.limit\nresult.abstract\n\n\n\n\n\n","category":"function"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetSpeciesByCommonName","category":"page"},{"location":"function/#SP2000China.GetSpeciesByCommonName","page":"Function","title":"SP2000China.GetSpeciesByCommonName","text":"GetSpeciesByCommonName(;common_name::String,api_key::String,page::Int=1)\n\nDescription\n\nQuery by common name and return species or subspecies information.\n\nParameters\n\ncommon_name: The common name, or a part of it.\napi_key: The API service key for registered users.\npage: The page number, an integer not less than 1. If not provided, it defaults to 1.\n\nResults\n\nresult: A structure of type GetSpeciesByCommonNameStruct.\nresult.data: Dictionary converted from JSON information.\nresult.count: Total number of matches.\nresult.page: Current data page.\nreult.limit: Number of items displayed per page.\nresult.abstract: Refined data frame.\n\nExample\n\nusing SP2000China;\nyour_common_name = \"土人参\";\nyour_api_key = \"Please register an account and obtain an API key\";\nyour_page = 1;\nresult = GetSpeciesByCommonName(common_name=your_common_name,api_key=your_api_key,page=your_page);\nresult.data\nresult.count\nresult.page\nreult.limit\nresult.abstract\n\n\n\n\n\n","category":"function"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetSpeciesByNameCode","category":"page"},{"location":"function/#SP2000China.GetSpeciesByNameCode","page":"Function","title":"SP2000China.GetSpeciesByNameCode","text":"GetSpeciesByNameCode(;name_code::String,api_key::String)\n\nDescription\n\nRetrieve detailed information based on the species ID.\n\nParameters\n\nname_code: The species ID.\napi_key: The API service key for registered users.\n\nResults\n\nresult: A structure of type GetSpeciesByNameCodeStruct.\nresult.data: Dictionary converted from JSON information.\nresult.abstract: Refined data frame.\n\nExample\n\nusing SP2000China;\nyour_name_code = \"1ac19d0d82d84dd2900d51a742fa9296\";\nyour_api_key = \"Please register an account and obtain an API key\";\nresult = GetSpeciesByNameCode(name_code=your_name_code,api_key=your_api_key);\nresult.data\nresult.abstract\n\n\n\n\n\n","category":"function"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetNameByKeyword","category":"page"},{"location":"function/#SP2000China.GetNameByKeyword","page":"Function","title":"SP2000China.GetNameByKeyword","text":"GetNameByKeyword(;keyword::String,api_key::String,page::Int=1)\n\nDescription\n\nSearch for name information based on a keyword.\n\nParameters\n\nkeyword: The name keyword (at least 2 characters).\napi_key: The API service key for registered users.\npage: The page number, an integer not less than 1. If not provided, it defaults to 1.\n\nResults\n\nresult: A structure of type GetNameByKeywordStruct.\nresult.data: Dictionary converted from JSON information.\nresult.count: Total number of matches.\nresult.page: Current data page.\nreult.limit: Number of items displayed per page.\nresult.abstract: Refined data frame.\n\nExample\n\nusing SP2000China;\nyour_keyword=\"柳莺\";\nyour_api_key = \"Please register an account and obtain an API key\";\nyour_page = 1;\nresult = GetNameByKeyword(keyword=your_keyword,api_key=your_api_key,page=your_page);\nresult.data\nresult.count\nresult.page\nreult.limit\nresult.abstract\n\n\n\n\n\n","category":"function"},{"location":"function/#Other","page":"Function","title":"Other","text":"","category":"section"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.SP2000China","category":"page"},{"location":"function/#SP2000China.SP2000China","page":"Function","title":"SP2000China.SP2000China","text":"The Julia package for obtaining information on the list of biological species, SP2000China.\n\n\n\n\n\n","category":"module"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetFamiliesByFamilyNameStruct","category":"page"},{"location":"function/#SP2000China.GetFamiliesByFamilyNameStruct","page":"Function","title":"SP2000China.GetFamiliesByFamilyNameStruct","text":"Construct a structure to store the results of the function GetFamiliesByFamilyName.\n\n\n\n\n\n","category":"type"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetSpeciesByFamilyIdStruct","category":"page"},{"location":"function/#SP2000China.GetSpeciesByFamilyIdStruct","page":"Function","title":"SP2000China.GetSpeciesByFamilyIdStruct","text":"Construct a structure to store the results of the function GetSpeciesByFamilyId.\n\n\n\n\n\n","category":"type"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetSpeciesByScientificNameStruct","category":"page"},{"location":"function/#SP2000China.GetSpeciesByScientificNameStruct","page":"Function","title":"SP2000China.GetSpeciesByScientificNameStruct","text":"Construct a structure to store the results of the function GetSpeciesByScientificName.\n\n\n\n\n\n","category":"type"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetSpeciesByCommonNameStruct","category":"page"},{"location":"function/#SP2000China.GetSpeciesByCommonNameStruct","page":"Function","title":"SP2000China.GetSpeciesByCommonNameStruct","text":"Construct a structure to store the results of the function GetSpeciesByCommonName.\n\n\n\n\n\n","category":"type"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetSpeciesByNameCodeStruct","category":"page"},{"location":"function/#SP2000China.GetSpeciesByNameCodeStruct","page":"Function","title":"SP2000China.GetSpeciesByNameCodeStruct","text":"Construct a structure to store the results of the function GetSpeciesByNameCode.\n\n\n\n\n\n","category":"type"},{"location":"function/","page":"Function","title":"Function","text":"SP2000China.GetNameByKeywordStruct","category":"page"},{"location":"function/#SP2000China.GetNameByKeywordStruct","page":"Function","title":"SP2000China.GetNameByKeywordStruct","text":"Construct a structure to store the results of the function GetNameByKeyword.\n\n\n\n\n\n","category":"type"},{"location":"acknowledgement/#Acknowledgement","page":"Acknowledgement","title":"Acknowledgement","text":"","category":"section"},{"location":"acknowledgement/","page":"Acknowledgement","title":"Acknowledgement","text":"Thank you, Jinbao the little cat, for not stepping on my keyboard.","category":"page"}]
}