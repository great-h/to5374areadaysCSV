# coding: utf-8
require "to5374areadaysCSV/version"
require 'csv'

class To5374areadaysCSV
  FAMILY_GTYPES = ["不燃", "可燃", "リプラ", "他プラ", "資源"].freeze

  def generate
    areas = load_areas
    if File.exist?('output')
      Dir.mkdir('output')
    end
    output_file = CSV.open('output/area_day.csv', 'w') do |csv|
      csv << area_days_headers
      areas.each do |area|
        gabage_table = load_gabage_table(area)
        big_gabage_table = load_big_gabage_table(area)
        wards = load_wards(area)
        wards.each do |ward|
          row = table[ward]
          csv << row
        end
      end
    end
  end

  def load_areas
    ["中区"]
  end

  def load_gabage_table(area)
    filename = "resource/2016/1家庭ゴミ収集日（#{area}）.csv"
    load_table_base(area, filename, FAMILY_GTYPES)
  end

  def load_big_gabage_table(area)
    filename = "resource/2016/2大型ゴミ収集日（#{area}）.csv"
    load_table_base(area, filename, ["大型"])
  end

  def load_table_base(area, filename, gtypes)
    hash = {}
    CSV.foreach(filename, encoding: 'Shift_JIS:UTF-8', headers: :first_row) do |row|
      date = Date.parse(row['年月日'])
      (row.headers - ['年月日', '曜']).each do |key|
        gtype = row[key]
        group = hash.fetch(key, {})
        if gtype != nil
          raise "no support gtypes: #{gtype}" unless gtypes.include? gtype
          g_dates = group.fetch(gtype, [])
          g_dates << date.strftime("%Y%m%d")
          group[gtype] = g_dates
          hash[key] = group
        end
      end
    end
    hash
  end

  def area_days_headers
    %W[地名 センター 可燃ゴミ ペットボトル リサイクルプラ 資源ゴミ 有害ゴミ その他プラ 大型ゴミ 不燃ゴミ]
  end
end
