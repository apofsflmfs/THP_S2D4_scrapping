require 'nokogiri'
require 'open-uri'

@storage_file = open("email_des_deputés.txt", 'w')


def get_email_from_deputy_url(deputy_url)
  page = Nokogiri::HTML(open(deputy_url))
  page_as = page.xpath('//dd/ul/li/a')
  page_as.each do |page_a|
    href = page_a['href']
    if href =~ /mailto/
      puts href[7..-1]
      return href[7..-1]
    end
  end
end

def get_deputy_url_from_assemblee_page
  page = Nokogiri::HTML(open('http://www2.assemblee-nationale.fr/deputes/liste/alphabetique'))
  deputy_as = page.xpath('//*[@id="deputes-list"]/div/ul/li/a')
  deputy_url = {}
  deputy_as.map do |deputy_a|
    link = deputy_a['href']
    deputy_url[deputy_a.text] = "http://www2.assemblee-nationale.fr"+deputy_a['href']
  end
  return deputy_url
end

def perform
  result = {}
  get_deputy_url_from_assemblee_page.each do |deputy_name, deputy_url|
    result[deputy_name] = get_email_from_deputy_url(deputy_url)
    @storage_file.write("#{deputy_name} peut être contacté(e) à #{result[deputy_name]}")
    @storage_file.write("\n")
  end
  puts result
end

perform
