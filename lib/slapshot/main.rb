require 'rest_client'
require 'json'
require 'formatador'
require 'spreadsheet'

def get_token_file
  homes = ["HOME", "HOMEPATH"]
  realHome = homes.detect {|h| ENV[h] != nil}
  ENV[realHome] + '/.slapshot_token' unless !realHome
end

def create_token(url, username, password)

  begin
    token = RestClient.get url + '/token/auth', :params => { :u => username, :p => password }
  rescue RestClient::BadRequest => e
    return nil
  end

  File.open(get_token_file, 'w') {|f| 
    f.write(token)
  }
  
  token
end

def remove_token(url)

  token = get_token

  res = RestClient.get url + '/token/deauth', :params => { :t => token }
  raise "Token de-authorization failed" if res != "success"

  File.delete(get_token_file)
  
  token
  
end

def get_token

  if not File.exists? get_token_file
    raise "Could not find a token file to read from"
  end
  
  File.open(get_token_file, 'r').read
end

class Appshot
  
  def initialize(url, token, instance)
    @instance = instance
    @api = RestClient::Resource.new url, :timeout => -1, :headers => {'Appshot-AuthToken' => token, 'Appshot-Instance' => instance}
  end
  
  def search(query, count, full)
    
    response = @api["service/api/search"].get :params => { :i => @instance, :q => query, :c => count, :f => full }, :content_type => :json, :accept => :json
    
    json_response = JSON.parse(response.body)
    
    if (Integer(json_response['count']) < Integer(count))
      count = json_response['count']
    end
    
    puts "Found #{json_response['count']} total results, retrieving #{count} results in #{json_response['search_time']} ms."
    json_response['docs']
    
  end

  def to_table(result)
      Formatador.display_table(result)
  end

  def to_xls(result, out)
    
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => 'Search Results'

    columns = ['name', 'entity_type']

      rownum = 0
      for column in columns
          sheet1.row(rownum).push column
      end
      for row in result
        rownum += 1
        for column in columns
          sheet1.row(rownum).push row[column].nil? ? 'N/A' : row[column]
        end
      end
      book.write(out)    
  end
  
end