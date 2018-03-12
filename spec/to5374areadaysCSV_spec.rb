# coding: utf-8
require 'spec_helper'

describe To5374areadaysCSV do
  let(:area) { { index: 1, name: '中区' } }
  let(:date) { Date.today }
  let(:year) { date.year }

  it 'has a version number' do
    expect(To5374areadaysCSV::VERSION).not_to be nil
  end

  it '#load_garbage_table' do
    table = To5374areadaysCSV.new.load_garbage_table(area, year)
    expect(table.keys.count).to eq(14)
    expect(table["1"].keys).to match_array(["不燃", "可燃", "リプラ", "他プラ", "資源"])
  end

  it '#load_big_garbage_table' do
    table = To5374areadaysCSV.new.load_big_garbage_table(area, year)
    expect(table.keys.count).to eq(14)
    expect(table["1"].keys).to eq(["大型"])
  end

  it '#create_csv' do
    rows = To5374areadaysCSV.new.build_csv([area], date)
    expect(rows[0].count).to eq(10)
  end
end
