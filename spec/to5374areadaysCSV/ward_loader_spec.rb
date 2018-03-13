# coding: utf-8
require 'spec_helper'
require 'to5374areadaysCSV/ward_loader'

describe To5374areadaysCSV::WardLoader do
  it '#load' do
    table = To5374areadaysCSV::WardLoader.load(2017, 1, '中区')
    row = table.first
    expect(row['町名']).to eq "榎町"
    expect(row['よみ']).to eq "えのまち"
    expect(row['区']).to eq "中区"
    expect(row['グループ']).to eq "8"
  end
end
