using HTTP,JSON,URIParser,DataFrames

"""
Construct a structure to store the results of the function `GetFamiliesByFamilyName`.
"""
struct GetFamiliesByFamilyNameStruct
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
`GetFamiliesByFamilyName(;family_name::String,api_key::String,page::Int=1)`\n
# Description\n
* Query by family name and return a collection of family IDs.\n
# Parameters\n
* `family_name`: The family name, or a part of it, supporting both Latin and Chinese names.\n
* `api_key`: The API service key for registered users.\n
* `page`: The page number, an integer not less than 1. If not provided, it defaults to 1.\n
# Results\n
* `result`: A structure of type `GetFamiliesByFamilyNameStruct`.\n
* `result.data`: Dictionary converted from JSON information.\n
* `result.count`: Total number of matches.\n
* `result.page`: Current data page.\n
* `result.limit`: Number of items displayed per page.\n
* `result.abstract`: Refined data frame.\n
# Example\n
```
using SP2000China;
your_family_name = "Coriariaceae";
your_api_key = "Please register an account and obtain an API key";
your_page = 1;
result = GetFamiliesByFamilyName(family_name=your_family_name,api_key=your_api_key,page=your_page);
result.data
result.count
result.page
result.limit
result.abstract
```
"""
function GetFamiliesByFamilyName(;family_name::String,api_key::String,page::Int=1)
    # Store the base URL for the API
    url = "http://www.sp2000.org.cn/api/v2/getFamiliesByFamilyName"
    # URL-encode the family_name
    encoded_family_name = URIParser.escape(family_name)
    # Build the complete URL request
    response = HTTP.get("$url?apiKey=$api_key&familyName=$encoded_family_name&page=$page")
    # If the HTTP response status code is 200, the request is successful
    if response.status == 200
        # Convert response.body to a string and parse JSON data using JSON.parse
        data = JSON.parse(String(response.body))
        # Total number of matches
        int_count = data["data"]["count"]
        # Current data page
        int_page = data["data"]["page"]
        # Extract the number of items displayed per page
        int_limit = data["data"]["limit"]
        # Extract family information
        dict_familes = data["data"]["familes"]
        # Integrate family information into a data frame, sorted by column names
        df_familes = DataFrames.DataFrame(dict_familes)
        ordered_columns = ["kingdom", "kingdom_c", 
                           "phylum", "phylum_c", 
                           "class", "class_c", 
                           "order", "order_c", 
                           "family", "family_c", 
                           "record_id"]
        df_result = df_familes[:,ordered_columns]
        # Construct the result
        result=GetFamiliesByFamilyNameStruct(data,int_count,int_page,int_limit,df_result)
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
