using HTTP,JSON,URIParser,DataFrames

"""
Construct a structure to store the results of the function `GetNameByKeyword`.
"""
struct GetNameByKeywordStruct
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
`GetNameByKeyword(;keyword::String,api_key::String,page::Int=1)`\n
# Description\n
* Search for name information based on a keyword.\n
# Parameters\n
* `keyword`: The name keyword (at least 2 characters).\n
* `api_key`: The API service key for registered users.\n
* `page`: The page number, an integer not less than 1. If not provided, it defaults to 1.\n
# Results\n
* `result`: A structure of type `GetNameByKeywordStruct`.\n
* `result.data`: Dictionary converted from JSON information.\n
* `result.count`: Total number of matches.\n
* `result.page`: Current data page.\n
* `result.limit`: Number of items displayed per page.\n
* `result.abstract`: Refined data frame.\n
# Example\n
```
using SP2000China;
your_keyword="柳莺";
your_api_key = "Please register an account and obtain an API key";
your_page = 1;
result = GetNameByKeyword(keyword=your_keyword,api_key=your_api_key,page=your_page);
result.data
result.count
result.page
result.limit
result.abstract
```
"""
function GetNameByKeyword(;keyword::String,api_key::String,page::Int=1)
    # Store the base URL for the API
    url = "http://www.sp2000.org.cn/api/v2/getNameByKeyword"
    # URL-encode the keyword
    encoded_keyword = URIParser.escape(keyword)
    # Initialize the result
    result = nothing
    # Handle exceptions
    try
        # Build the complete URL request
        response = HTTP.get("$url?apiKey=$api_key&keyword=$encoded_keyword&page=$page")
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
            # Extract the required information
            df_result = DataFrames.DataFrame(chinese_name = [item["name_c"] for item in data["data"]["names"]],
                                            scientific_name = [item["name"] for item in data["data"]["names"]],
                                            rank = [item["rank"] for item in data["data"]["names"]],
                                            taxon_group = [item["taxongroup"] for item in data["data"]["names"]],
                                            hierarchy_code = [item["hierarchyCode"] for item in data["data"]["names"]])
            # Construct the result
            result = GetNameByKeywordStruct(data,int_count,int_page,int_limit,df_result)
        end
    # Handle exceptions
    catch e
        code_400 = "If the HTTP response status code is 400, the request failed."
        code_401 = "If the HTTP response status code is 401, API error."
        println("Warning:\n$code_400\n$code_401\n \nMessage:\n$e")
    end
    # Return the result
    return(result)
end
