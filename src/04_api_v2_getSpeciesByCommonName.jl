using HTTP
using JSON
using URIParser
using DataFrames

"""
Construct a structure to store the results of the function `GetSpeciesByCommonName`.
"""
struct GetSpeciesByCommonNameStruct
    # Dictionary converted from JSON information
    data::Dict
    # Total number of matches
    count::Int
    # Current data page
    page::Int
    # Number of items displayed per page
    limit::Int
    # Refined data frame
    abstract::DataFrame
end

"""
`GetSpeciesByCommonName(;common_name::String,api_key::String,page::Int=1)`\n
# Description\n
* Query by common name and return species or subspecies information.\n
# Parameters\n
* `common_name`: The common name, or a part of it.\n
* `api_key`: The API service key for registered users.\n
* `page`: The page number, an integer not less than 1. If not provided, it defaults to 1.\n
# Results\n
* `result`: A structure of type `GetSpeciesByCommonNameStruct`.\n
* `result.data`: Dictionary converted from JSON information.\n
* `result.count`: Total number of matches.\n
* `result.page`: Current data page.\n
* `reult.limit`: Number of items displayed per page.\n
* `result.abstract`: Refined data frame.\n
# Example\n
```
using SP2000China;
your_common_name = "土人参";
your_api_key = "Please register an account and obtain an API key";
your_page = 1;
result = GetSpeciesByCommonName(common_name=your_common_name,api_key=your_api_key,page=your_page);
result.data
result.count
result.page
reult.limit
result.abstract
```
"""
function GetSpeciesByCommonName(;common_name::String,api_key::String,page::Int=1)
    # Store the base URL for the API
    url = "http://www.sp2000.org.cn/api/v2/getSpeciesByCommonName"
    # URL-encode the common_name
    encoded_common_name = URIParser.escape(common_name)
    # Build the complete URL request
    response = HTTP.get("$url?apiKey=$api_key&commonName=$encoded_common_name&page=$page")
    # If the HTTP response status code is 200, the request is successful
    if response.status == 200
        # Convert response.body to a string and parse JSON data using JSON.parse
        data = JSON.parse(String(response.body))
        # Total number of matches
        int_count = data["data"]["count"]
        # Current data page
        int_page = data["data"]["page"]
        # Number of items displayed per page
        int_limit = data["data"]["limit"]
        # Extract species information from the dictionary
        dict_species = data["data"]["species"]
        # Prepare a data frame to organize dict_species
        df_result = DataFrames.DataFrame(scientific_name = String[],
                                        chinese_name = String[],
                                        common_names = String[],
                                        kingdom = String[],
                                        phylum = String[],
                                        class = String[],
                                        order = String[],
                                        family = String[],
                                        genus = String[],
                                        species = String[])

        # Iterate over the dictionary and add data
        for species_i in dict_species
            # Further extract information
            accepted_name_info = species_i["accepted_name_info"]
            # Get the scientific name
            scientific_name = accepted_name_info["scientificName"]
            # Get the Chinese name
            chinese_name = accepted_name_info["chineseName"]
            # Get the common names
            common_names = join(accepted_name_info["CommonNames"],",")
            # Get the classification information
            taxon_tree = accepted_name_info["taxonTree"]
            # Push the information to the data frame
            push!(df_result,(scientific_name,
                            chinese_name,
                            common_names,
                            taxon_tree["kingdom"],
                            taxon_tree["phylum"],
                            taxon_tree["class"],
                            taxon_tree["order"],
                            taxon_tree["family"],
                            taxon_tree["genus"],
                            taxon_tree["species"]))
        end
        # Construct the result
        result = GetSpeciesByCommonNameStruct(data,int_count,int_page,int_limit,df_result)
        # Return the result
        return(result)
    # If the HTTP response status code is 400, the request failed
    elseif response.status == 400
        println("Bad request\n","HTTP: ", response.status, "\nDetails:\n",response)
    # If the HTTP response status code is 401, API error
    elseif response.status == 401
        println("API token error\n","HTTP: ", response.status, "\nDetails:\n",response)
    # An unknown error occurred
    else 
        println("Unknown error\n","HTTP: ", response.status, "\nDetails:\n",response)
    end
end
