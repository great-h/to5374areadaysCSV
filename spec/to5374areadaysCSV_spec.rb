# coding: utf-8
require 'spec_helper'
require 'to5374areadaysCSV'

describe To5374areadaysCSV do
  let(:area) { { index: 1, name: '中区' } }
  let(:date) { Date.today }
  let(:year) { date.year }

  it 'has a version number' do
    expect(To5374areadaysCSV::VERSION).not_to be nil
  end
end
