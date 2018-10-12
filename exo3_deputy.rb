require 'nokogiri'
require 'open-uri'

@storage_file = open("exo3_deputy_emails.txt", 'w')


def get_email_from_deputy_url(deputy_url)
  page = Nokogiri::HTML(open(deputy_url))
  #better!!! => email = page.xpath("//a[starts-with(@href, 'mailto')]")
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

def name_transform(name)
  first_space = name =~ / /
  first_name = name[first_space+1..-1]
  seconde_space = first_name =~ / /
  last_name = first_name[seconde_space+1..-1]
  first_name = first_name[0...seconde_space]
  return [first_name,last_name]
end

def perform
  result = []

  get_deputy_url_from_assemblee_page.each do |deputy_name, deputy_url|
    full_name = name_transform(deputy_name)
    deputy_email = get_email_from_deputy_url(deputy_url)
    result << {:first_name => full_name[0], :last_name => full_name[1], :email => deputy_email} 
    @storage_file.write("#{deputy_name} peut être contacté(e) à #{deputy_email}")
    @storage_file.write("\n")
  end
  @storage_file.write("******* Tableau de hash final*******\n")
  @storage_file.write("#{result}")
  puts result
end

perform
