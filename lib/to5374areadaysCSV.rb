# coding: utf-8
require "to5374areadaysCSV/version"
require "to5374areadaysCSV/ward_loader"
require "to5374areadaysCSV/garbage_date_loader"
require 'date'
require 'csv'

module To5374areadaysCSV
  module_function

  def generate(date)
    unless File.exist?('output')
      Dir.mkdir('output')
    end

    output_file = CSV.open('output/area_days.csv', 'w') do |csv|
      csv << area_days_headers
      load_areas.each do |area|
        generate_by_area(area[:index], area[:name], date) do |row|
          csv << row
        end
      end
    end
  end

  # yearの区のデータから区のよみからarea_tableの情報へのテーブルを作成する
  def build_ward_group(wards, area_table)
    wards.map do |ward| 
      group_id = ward["グループ"]
      ward_name = ward["よみ"]
      group = area_table[group_id]
      [ward_name, group]
    end.to_h
  end

  # 区のデータを生成する
  # 去年のデータと今年のデータからデータを構築してくっつけてあげる
  def generate_by_area(area_index, area_name, date)
    last_year = date.year-1
    year = date.year
    last_year_table = generate_by_year_and_area(last_year, area_index, area_name, date)
    last_year_wards = WardLoader.load(last_year, area_index, area_name)

    this_year_table = generate_by_year_and_area(year, area_index, area_name, date)
    this_year_wards = WardLoader.load(year, area_index, area_name)

    this_year_group = build_ward_group(this_year_wards, this_year_table)
    last_year_group = build_ward_group(last_year_wards, last_year_table)
    this_year_wards.each do |ward|
      ward_name = ward['よみ']
      group = this_year_group[ward_name].map { |garbage_type, date_list|
        [garbage_type, last_year_group[ward_name][garbage_type] + date_list]
      }.to_h
      yield build_csv_row(group, ward)
    end
  end

  # dateより新しいものだけにする
  def filter_date(group_table, date)
    group_table
      .map { |group_id, garbage_table|
        filtered_garbage_table = garbage_table.map { |garbage_type, date_list|
          [garbage_type, date_list.select {|d| date < d }]
        }.to_h
        [group_id, filtered_garbage_table]
      }
      .to_h
  end

  def generate_by_year_and_area(year, area_index, area_name, date)
    wards = WardLoader.load(year, area_index, area_name)
    garbages_group_table = filter_date(GarbageDateLoader.load_garbage(year, area_index, area_name), date)
    big_garbages_group_table = filter_date(GarbageDateLoader.load_big_garbage(year, area_index, area_name), date)

    wards.map { |ward|
      group_id = ward["グループ"]
      garbage = garbages_group_table[group_id]
      big_garbage = big_garbages_group_table[group_id]
      [group_id, garbage.merge(big_garbage)]
    }.to_h
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
  # ward: ある区の情報 Hash
  def build_csv_row(group, ward)
    area = ward["区"]
    ward_name = ward["町名"].gsub(",", "・")
    yomi = ward["よみ"]
    row_header = "#{area} #{ward_name}(#{yomi})"

    columns_order = %W'可燃 リプラ リプラ 資源 資源 他プラ 大型 不燃'
    columns = columns_order.map.with_index do |name, index|
      date_list = group[name].map { |n| n.strftime("%Y%m%d")}
      (date_list + ["*#{index+1}"]).join(' ')
    end
    [row_header, "", *columns]
  end

  def load_year_table(area, year)
    garbage_table = load_garbage_table(area, year)
    big_garbage_table = load_big_garbage_table(area, year)
    wards = load_wards(area, year)
    wards.map do |ward|
      key = ward["グループ"]
      row = garbage_table[key]
      row.merge(big_garbage_table[key])
    end
  end

  def area_days_headers
    %W[地名 センター 可燃ごみ ペットボトル リサイクルプラ 資源ごみ 有害ごみ その他プラ 大型ごみ 不燃ごみ]
  end
end
