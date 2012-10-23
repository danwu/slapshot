require 'rest_client'
require 'json'
require 'formatador'
require 'spreadsheet'

class SlapshotConnection
  
  def initialize(url, instance, username, password)
    @app = "Portfolio"
    @instance = instance
    @api = RestClient::Resource.new url, :user => username, :password => password, :timeout => -1
  end
  
  def set_app(app)
    @app = app
  end

  def search(query, count)
    
    puts @api["search"].url
    
    response = @api["search"].get :params => { :client => @instance, :app => @app, :q => query, :c => count }, :content_type => :json, :accept => :json
    
    
    
    json_response = JSON.parse(response.body)
    puts "Found #{json_response['count']} total results, retrieving #{count} results in #{json_response['search_time']} ms."
    
    json_response['docs']
  end

  def to_table(result)
      Formatador.display_table(result)
  end

  def to_xls(result, out)
    
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => 'Search Results'

    columns = ['name', 'entity_type', 'highlight']

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