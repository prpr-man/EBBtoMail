## なにこれ
  鈴鹿高専の各教室にある電光掲示板に新着があればメールでその内容をお知らせするスクリプト．

## 動作環境
  適当なサーバでcronで叩くことを想定しています．Rubyは1.9以上なら動くと思います．
  サーバなんかもってねえよって人はHerokuの無料枠とかでも動くんじゃないですかね？よく知りませんけど．

## インストール方法
  userinfo.confを自分用に設定して

```
$ git clone 
$ cd EBBtoMail
$ bundle install
```

  あとは，cronでEBBtoMail.rbを実行してください．cronでスクリプトを叩く間隔はお好きな時間でいいですが，あんまり頻繁にはやめましょう．某図書館の件もありますので．

## Lisence
  This software is released under the MIT License, see LICENSE.txt.


