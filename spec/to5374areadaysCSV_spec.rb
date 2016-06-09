# coding: utf-8
require 'spec_helper'

describe To5374areadaysCSV do
  it 'has a version number' do
    expect(To5374areadaysCSV::VERSION).not_to be nil
  end

  it 'load_gabage_table' do
    table = To5374areadaysCSV.new.load_gabage_table('中区')
    expect(table.keys.count).to eq(14)
    expect(table["1"].keys).to eq( ["不燃", "可燃", "リプラ", "他プラ", "資源"])
  end
end
