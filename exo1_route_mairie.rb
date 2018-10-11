require 'nokogiri'
require 'open-uri'

@storage_file = open("exo1_townhall_emails.txt", 'w')


def get_the_email_of_a_townhall_from_its_webpage(townhall_url)
  page = Nokogiri::HTML(open(townhall_url))
  email = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
  puts email
  return email
end

def get_all_the_urls_of_val_doise_townhalls(department_url)
  page = Nokogiri::HTML(open(department_url))
  a_elements = page.xpath('//a')

  result = {}
  a_elements.each do |a_element|
    link = a_element['href']
    if link.include?('./95/')
      link[0] = "http://annuaire-des-mairies.com"
      result[a_element.text] = link #mon hash final récupère en clé le nom de la ville (a_element.text) et en valeur l'url (link)
    end
  end

  return result
end

def get_all_the_emails_of_val_doise_townhalls
  val_doise_emails = []

  get_all_the_urls_of_val_doise_townhalls("http://annuaire-des-mairies.com/val-d-oise.html").each do |townhall_name, townhall_url|
    val_doise_emails << {"name" => townhall_name, "email" => get_the_email_of_a_townhall_from_its_webpage(townhall_url)}
  end
  @storage_file.write(val_doise_emails)
  return val_doise_emails
end

  puts get_all_the_emails_of_val_doise_townhalls
  # puts get_all_the_emails_of_val_doise_townhalls("http://annuaire-des-mairies.com/val-d-oise.html").select {|k,v| v==""}
