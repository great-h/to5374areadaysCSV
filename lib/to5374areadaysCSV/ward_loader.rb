# coding: utf-8
require 'csv'

module To5374areadaysCSV::WardLoader
  module_function
  
  def load(year, area_index, area_name)
    name = filename(year, area_index, area_name)
    CSV.foreach(name, encoding: 'Shift_JIS:UTF-8', headers: :first_row).map do |l|
      l.tap {
        l['区'] = area_name
      }
    end
  end

  def filename(year, area_index, area_name)
    project_root = 3.times.reduce(__FILE__) do |acc|
      File.dirname(acc)
    end
    File.join(project_root, "resource", year.to_s, "3-#{area_index}#{area_name}町名.csv")
  end
end
