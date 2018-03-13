# To5374areadaysCSV

広島市の家庭ごみの収集日のデータから[5374.j4 　広島版](hiroshima.5374.jp)で利用可能なデータを構築するスクリプトです。

## Usage

本リポジトリを clone して

```
$ bundle install
$ bin/createAreaCSV
```

とすることで`output`ディレクトリに area_days.csv が生成されます

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

本リポジトリには「広島市 環境局業務部業務第一課」が公開している「[度家庭ゴミ収集日程表](http://www.city.hiroshima.lg.jp/www/opendatamain/contents/1464164589110/index.html)」のデータを含んでいます。平成２８年度家庭ゴミ収集日程表は CC－BY(表示)で公開されています。

[![ccby](http://www.city.hiroshima.lg.jp/www/image/opendata/ccby.png)](http://creativecommons.org/licenses/by/4.0/deed.ja)
