# coding: utf-8
require 'spec_helper'
require 'to5374areadaysCSV/garbage_date_loader'

describe To5374areadaysCSV::GarbageDateLoader do
  include To5374areadaysCSV::GarbageDateLoader
  it '#load' do
    table = load_garbage(2017, 1, '中区')
    group_id = "1"
    group_garbage_date = table[group_id]
    expect(group_garbage_date["可燃"].first.class).to be Date
  end
end
