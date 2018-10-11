require 'nokogiri'
require 'open-uri'

@storage_file = open("crypto_value.txt", 'w')


#technique où on passe par la page de la monnaie pour obtenir le cours de la monnaie => C'est plus rapide
def get_crypto_value_short(coinmarket_url)
  page = Nokogiri::HTML(open(coinmarket_url))
  puts "page chargée =>> ok"
  crypto_as = page.xpath('//a[contains(@class, "currency-name-container")]')
  prices = page.xpath('//a[@class = "price"]')
  result ={}
  crypto_as.each_with_index do |crypto_a, index|
    crypto_name = crypto_a.text
    crypto_price = prices[index].text
    result[crypto_name] = crypto_price
    end
  return result
end

def perform
  i = 1
  while(true)
    puts "boucle n°#{i} lancée"
    @storage_file.write("\n") 
    @storage_file.write("*********************enregistrement de #{Time.now.strftime("%d/%m/%Y %H:%M")}*********************")
    @storage_file.write("\n") 
    @storage_file.write(get_crypto_value_short('https://coinmarketcap.com/all/views/all/'))
    puts "boucle n°#{i} terminée. En sleep......"

    sleep(600)
    i +=1
  end
end

perform

#technique où on récupère le row
def get_crypto_value_by_row (coinmarket_url)
  page = Nokogiri::HTML(open(coinmarket_url))
  puts "=> page chargée"
  crypto_row = page.xpath('//tr')
  puts crypto_row[1]
end 
# get_crypto_value_by_row('https://coinmarketcap.com/all/views/all/')



#technique où on passe par la page de la monnaie pour obtenir le cours de la monnaie => C'est looooooooooooong

def get_value_from_url(crypto_url)
  page = Nokogiri::HTML(open(crypto_url))
  return page.xpath('//*[@id="quote_price"]/span[1]').text
end

def get_crypto_value_loooong(coinmarket_url)
  page = Nokogiri::HTML(open(coinmarket_url))
  crypto_as = page.xpath('//a[contains(@class, "currency-name-container")]')
  result ={}
  crypto_as.each do |crypto_a|
    link_crypto = "https://coinmarketcap.com"+crypto_a['href']
    result[crypto_a.text] = get_value_from_url(link_crypto)
    end
  return result
end