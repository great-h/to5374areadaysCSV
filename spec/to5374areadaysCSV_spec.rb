# coding: utf-8
require 'spec_helper'

describe To5374areadaysCSV do
  let(:area) { { index: 1, name: '中区' } }
  let(:year) { 2017 }

  it 'has a version number' do
    expect(To5374areadaysCSV::VERSION).not_to be nil
  end

  it '#load_gabage_table' do
    table = To5374areadaysCSV.new.load_gabage_table(area, year)
    expect(table.keys.count).to eq(14)
    expect(table["1"].keys).to match_array(["不燃", "可燃", "リプラ", "他プラ", "資源"])
  end

  it '#load_big_gabage_table' do
    table = To5374areadaysCSV.new.load_big_gabage_table(area, year)
    expect(table.keys.count).to eq(14)
    expect(table["1"].keys).to eq(["大型"])
  end

  it '#create_csv' do
    rows = To5374areadaysCSV.new.create_csv([area])
    expect(rows[0].count).to eq(10)
  end
end
