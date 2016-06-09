# coding: utf-8
require "to5374areadaysCSV/version"
require 'csv'

class To5374areadaysCSV
  FAMILY_GTYPES = ["不燃", "可燃", "リプラ", "他プラ", "資源"].freeze

  def generate
    if File.exist?('output')
      Dir.mkdir('output')
    end
    areas = load_areas
    rows = create_csv(areas)

    output_file = CSV.open('output/area_day.csv', 'w') do |csv|
      csv << area_days_headers
      rows.each do |row|
        csv << row
      end
    end
  end

  def load_areas
    ['中区', '佐伯区', '南区', '安佐北区', '安佐南区', '安芸区', '東区', '西区']
  end

  def create_csv(areas)
    year = 2016
    rows = []
    areas.each do |area|
      gabage_table = load_gabage_table(area, year)
      big_gabage_table = load_big_gabage_table(area, year)
      wards = load_wards(area, year)
      wards.each do |ward|
        key = ward["グループ"]
        row = gabage_table[key]
        table = Hash[row.merge(big_gabage_table[key]).map { |k,v| [k, v.join(" ")] }]
        w = ward["町名"]
        rows << ["#{area} #{w}", "", table["可燃"], table["リプラ"], table["リプラ"], table["資源"], table["資源"], table["他プラ"]]
      end
    end
    rows
  end

  def load_gabage_table(area, year)
    filename = "resource/#{year}/1家庭ゴミ収集日（#{area}）.csv"
    load_table_base(area, filename, FAMILY_GTYPES)
  end

  def load_big_gabage_table(area, year)
    filename = "resource/#{year}/2大型ゴミ収集日（#{area}）.csv"
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

  def load_wards(area, year)
    filename = "resource/#{year}/3#{area}町名.csv"
    CSV.read(filename, encoding: 'Shift_JIS:UTF-8', headers: :first_row)
  end

  def area_days_headers
    %W[地名 センター 可燃ゴミ ペットボトル リサイクルプラ 資源ゴミ 有害ゴミ その他プラ 大型ゴミ 不燃ゴミ]
  end
end
