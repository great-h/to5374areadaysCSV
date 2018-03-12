# coding: utf-8
require 'csv'

module To5374areadaysCSV::GarbageDateLoader
  module_function
  FAMILY_GTYPES = ["不燃", "可燃", "リプラ", "他プラ", "資源"].freeze

  def load_garbage(year, area_index, area_name)
    filename = garbase_filename(year, area_index, area_name)
    load(filename, FAMILY_GTYPES)
  end

  def load_big_garbage
    filename = big_garbase_filename(year, area_index, area_name)
    load(filename, ["大型"])
  end

  # @params filename 読み込みするファイル
  # @params gtypes このファイルで読み込みするごみの種類
  # @return { グループkey => { ごみの種類 => [日付] }}
  def load(filename, gtypes)
    hash = {}
    CSV.foreach(filename, encoding: 'Shift_JIS:UTF-8', headers: :first_row) do |row|
      date = Date.parse(row['年月日'])
      (row.headers - ['年月日', '曜']).each do |key|
        gtype = row[key]
        group = hash.fetch(key, {})
        if gtype != nil
          raise "no support gtypes: #{gtype}" unless gtypes.include? gtype
          g_dates = group.fetch(gtype, [])
          g_dates << date
          group[gtype] = g_dates
          hash[key] = group
        end
      end
    end
    hash
  end

  def project_root
    project_root = 3.times.reduce(__FILE__) do |acc|
      File.dirname(acc)
    end
  end

  def garbase_filename(year, area_index, area_name)
    filename = "1-#{area_index}家庭ごみ収集日（#{area_name}）.csv"
    File.join(project_root, "resource", year.to_s, filename)
  end

  def big_garbage_filename(year, area_index, area_name)
    filename = "2-#{area_index}大型ごみ収集日（#{area_name}）.csv"
    File.join(project_root, "resource", year.to_s, filename)
  end
end
