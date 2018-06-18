# encoding: utf-8

require 'yaml'

ReportTemplate.update_all({:ac_filter_def_id => nil, :excluir => true})
AcFilterOption.delete_all
AcFilter.delete_all
AcFilterDef.delete_all

puts "Iniciando importação dos filtros"
Dir.glob("#{Rails.root}/db/filters/*.yml").each do |f|
  params = YAML::load(File.open(f, 'r'))
  AcFilterDef.create(params)
  puts "Criado filtro: " + params["name"]
end
puts "FIM"

puts "Iniciando importação dos reports"
Dir.glob("#{Rails.root}/db/reports/*.yml").each do |f|
  params = YAML::load(File.open(f, 'r'))
  r = ReportTemplate.find_by_name(params["name"])
  if r.nil?
    if params["filter_name"]
      f = AcFilterDef.find_by_name(params.delete("filter_name"))
      if f
        params["ac_filter_def_id"] = f.id
      end
    end
    params["excluir"] = false
    ReportTemplate.create(params)
    puts "Criado relatório: " + params["name"]
  else
    if params["filter_name"]
      f = AcFilterDef.find_by_name(params.delete("filter_name"))
      if f
        params["ac_filter_def_id"] = f.id
      end
    end
    params["excluir"] = false
    r.update_attributes(params)
    puts "Atualizado relatório: " + params["name"]
  end
end
ReportTemplate.destroy_all(:excluir => true)
puts "finishing, closing, and going home"
