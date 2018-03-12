# coding: utf-8
require "to5374areadaysCSV/version"
require 'date'
require 'csv'

class To5374areadaysCSV
  FAMILY_GTYPES = ["不燃", "可燃", "リプラ", "他プラ", "資源"].freeze

  def generate(date = Date.today())
    unless File.exist?('output')
      Dir.mkdir('output')
    end
    areas = load_areas
    rows = build_csv(areas, date)

    output_file = CSV.open('output/area_days.csv', 'w') do |csv|
      csv << area_days_headers
      rows.each do |row|
        csv << row
      end
    end
  end

  def load_areas
    [
      { index: 1, name: '中区' },
      { index: 2, name: '東区' },
      { index: 3, name: '南区' },
      { index: 4, name: '西区' },
      { index: 5, name: '安佐南区' },
      { index: 6, name: '安佐北区' },
      { index: 7, name: '安芸区' },
      { index: 8, name: '佐伯区' }
    ]
  end

  # table: あるグループのゴミの日を保持した Hash。キーはゴミの種類 値は日付データ
  # ward: ある街の上をう表現する Hash
  def build_csv_row(table, ward, area)
    w = ward["町名"].gsub(",", "・")
    y = ward["よみ"]
    [
      "#{area[:name]} #{w}(#{y})",
      "",
      table["可燃"] + " *1",
      table["リプラ"] + " *2",
      table["リプラ"] + " *3",
      table["資源"] + " *4",
      table["資源"] + " *5",
      table["他プラ"] + " *6",
      table["大型"] + " *7",
      table["不燃"] + " *8"
    ]
  end

  #　出力するCSVのための二次元配列を作成する
  def build_csv(areas, date)
    year = date.year
    rows = []
    areas.each do |area|
      garbage_table = load_garbage_table(area, year)
      big_garbage_table = load_big_garbage_table(area, year)
      wards = load_wards(area, year)
      wards.each do |ward|
        key = ward["グループ"]
        row = garbage_table[key]
        table = Hash[row.merge(big_garbage_table[key]).map { |k,v| [k, v.join(" ")] }]
        rows << build_csv_row(table, ward, area)
      end
    end
    rows
  end

  def load_garbage_table(area, year)
    filename = "resource/#{year}/1-#{area[:index]}家庭ごみ収集日（#{area[:name]}）.csv"
    load_table_base(area, filename, FAMILY_GTYPES)
  end

  def load_big_garbage_table(area, year)
    filename = "resource/#{year}/2-#{area[:index]}大型ごみ収集日（#{area[:name]}）.csv"
    load_table_base(area, filename, ["大型"])
  end

  # @params filename 読み込みするファイル
  # @params gtypes このファイルで読み込みするごみの種類
  # @return { グループkey => { ごみの種類 => [日付] }}
  def load_table_base(filename, gtypes)
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
    filename = "resource/#{year}/3-#{area[:index]}#{area[:name]}町名.csv"
    CSV.read(filename, encoding: 'Shift_JIS:UTF-8', headers: :first_row)
  end

  def area_days_headers
    %W[地名 センター 可燃ゴミ ペットボトル リサイクルプラ 資源ゴミ 有害ゴミ その他プラ 大型ゴミ 不燃ゴミ]
  end
end
